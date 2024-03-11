require 'json'

class EmergenciesController < ApplicationController
  before_action :authenticate_user!

  def new
    @emergency = Emergency.new
    # chatgpt
    # if params[:chat]
    #   @chat = params[:chat]
    # else
    #   @chat = ""
    # end
    authorize @emergency
  end

  def create
    @emergency = Emergency.new(emergency_params)
    @emergency.user = current_user
    authorize @emergency

    # aqui vamos rodar o GPT retorna gravidade(prioridade)
    # @chat_response = JSON.parse(
    #   chatgpt_service("Por favor, avalie a seguinte ocorrência: #{@emergency_description}.
    #     Forneça uma avaliação da gravidade em uma escala de 0 (menos grave) a 20 (mais grave).
    #     Para determinar a categoria da ocorrência, atribua o número correspondente à categoria que melhor a descreve, de acordo com as seguintes opções (caso não se enquadre em nenhuma, selecione 'Outros', ou seja, número 11):
    #     Acidentes de trânsito = 1;
    #     Mal súbito = 2;
    #     Ferimentos por queda = 3;
    #     Parada cardiorrespiratória = 4;
    #     Intoxicação ou envenenamento = 5;
    #     Problemas respiratórios = 6;
    #     Crises hipertensivas = 7;
    #     Complicações durante a gravidez ou parto = 8;
    #     Ferimentos por arma branca ou de fogo = 9;
    #     Reações alérgicas graves = 10;
    #     Outros = 11;
    #     A resposta deve ser uma única hash na seguinte estrutura:
    #     {\"gravidade\":integer, \"numero_pessoas_machucadas\":integer, \"categoria\":integer}.
    #     Não inclua nenhuma informação adicional além da hash.
    #     ").call)

    @chat_response = JSON.parse("{\"gravidade\":15, \"numero_pessoas_machucadas\":1, \"categoria\":3}")

    @emergency.gravity = @chat_response["gravidade"]
    @emergency.category = @chat_response["categoria"]
    @emergency.save!
    prioritize_emergencies_by_gravity
    find_ambulance(@emergency)


    if @emergency.save
      render turbo_stream: [
        turbo_stream.replace("chat_message", partial: "emergencies/chat_message", locals: {chat: @chat})
      ]
      # redirect_to new_emergency_path(chat: @chat), notice: 'Novo chamado foi criado.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    authorize @emergency
    @emergency = Emergency.find(params[:id])
    # aqui vamos atualizar o time final, local final
  end

  private

  def emergency_params
    params.require(:emergency).permit(:description, :n_people, :street, :neighborhood, :city, :local_type, :emergency_lat, :emergency_lon)
  end

  def save_without_validation
    save(validate: false)
  end

  # chatgpt
  def chatgpt_service(message)
    ChatgptService.new(message)
  end

  def prioritize_emergencies_by_gravity
    # seleciona as emergencias ativas, ou seja, nao encerradas
    @emergencies = Emergency.where(time_end: nil)
    # ordena pela gravidade mais alta para menos alta
    @emergencies.sort_by(&:gravity).reverse
  end

  def find_ambulance(emergency)
    # seleciona ambulancias ativas, nao socorrendo nenhuma emergencia ou socorrendo emergencia com gravidade abaixo 15 ou
    # socorrendo emergencia com gravidade abaixo dela
    # "procurar usando um through emergency.gravity"
    # restringe a procura para somente as ambulancias com emergencias menores que 15 ou menores que a emergencia atual
    emergency.gravity < 15 ? max_gravity = emergency.gravity : max_gravity = 15

    @schedules = Schedule.left_joins(:emergencies).where(active: true).where('emergencies.gravity < ? OR emergencies.id IS NULL', max_gravity)

    distances = {}
    @schedules.each do |schedule|
      # calcular distancia usando pitagoras ou geocode e colocar em uma hash (ok)
      distances[schedule.id] = calculate_distance(schedule, emergency)
    end
    # lembrar de testar se o autocomplete esta mandando lat e lon com , ou . (ok)
    # atribui a ambulancia com a menor distancia a emergencia (ok)
    emergency.schedule_id = distances.min_by { |id, distance| distance }&.first
    # se a ambulancia ja possuia uma emergencia em andamento, rodar o metodo find ambulance para a emergencia que ficou sem ambulancia
    raise

    # caso nao possua ambulancias ativas disponiveis, deverá aguardar uma ambulancia disponivel para rodar o find ambulance, ou seja,
    # toda vez que uma ambulancia receber um time_end, devera rodar um metodo para procurar emergencias sem schedule

  end

  def calculate_distance(schedule, emergency)
    # precisamos colocar latitude e longitude da emergencia e current lat lon para schedule
    Math.sqrt((((schedule.current_lat - emergency.emergency_lat) * 111.11) ** 2) + (((schedule.current_lon - emergency.emergency_lon) * 111.1) ** 2))
  end

end
