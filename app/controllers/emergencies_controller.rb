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
    authorize @emergency
    @emergency.user = current_user

    # aqui vamos rodar o GPT retorna gravidade(prioridade)
    @chat_response = JSON.parse(
      chatgpt_service("Por favor, avalie a seguinte ocorrência: #{@emergency_description}.
        Forneça uma avaliação da gravidade em uma escala de 0 (menos grave) a 20 (mais grave).
        Para definir a categoria da ocorrência, forneça o número correspondente à categoria de acordo com as seguintes opções:
        Acidentes de trânsito = 1;
        Mal súbito = 2;
        Ferimentos por queda = 3;
        Parada cardiorrespiratória = 4;
        Intoxicação ou envenenamento = 5;
        Problemas respiratórios = 6;
        Crises hipertensivas = 7;
        Complicações durante a gravidez ou parto = 8;
        Ferimentos por arma branca ou de fogo = 9;
        Reações alérgicas graves = 10;
        Outros = 11;
        Por favor, insira o número correspondente à categoria da ocorrência, seguindo o padrão anterior (categoria = número da categoria).
        A resposta deve ser uma única hash na seguinte estrutura:
        {\"gravidade\":integer, \"numero_pessoas_machucadas\":integer, \"categoria\":integer}.
        Não inclua nenhuma informação adicional além da hash.
        ").call)

    @emergency.gravity = @chat_response["gravidade"]
    @emergency.category = @chat_response["categoria"]

    if @emergency.save
      raise
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
    params.require(:emergency).permit(:description, :n_people, :street, :neighborhood, :city)
  end

  def save_without_validation
    save(validate: false)
  end
  # chatgpt
  def chatgpt_service(message)
    ChatgptService.new(message)
  end
end
