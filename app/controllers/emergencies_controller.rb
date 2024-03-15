require 'json'
require 'date'

class EmergenciesController < ApplicationController
  before_action :authenticate_user!

  def new
    @emergency = Emergency.new
    authorize @emergency
  end

  def obtain_markers
    @emergency = Emergency.new
    authorize @emergency
    @schedule = Schedule.new
    authorize @schedule

    emergencies_markers = Emergency.where(time_end: nil).map do |emergency|
      {
        lat: emergency.emergency_lat,
        lng: emergency.emergency_lon,
        marker_html: render_to_string(partial: "emergency"),
        info_window_html: render_to_string(partial: "info_window", locals: { emergency: emergency }),
      }
    end

    schedules_markers = Schedule.where(active: true).map do |schedule|
      {
        lat: schedule.current_lat,
        lng: schedule.current_lon,
        marker_html: render_to_string(partial: "schedule_marker"),
        info_window_html: render_to_string(partial: "info_window_schedule", locals: { schedule: schedule })
      }
    end
    render json: { emergencies_markers: emergencies_markers, schedules_markers: schedules_markers }
  end

  def obtain_routes
    @schedule = Schedule.new
    authorize @schedule
    @emergency = Emergency.new
    authorize @emergency
    routes = []
    @schedules = Schedule.joins(:emergencies).where(emergencies: { time_end: nil })
    # Iterar sobre cada schedule e seu emergency correspondente
    @schedules.each do |schedule|
      emergency = Emergency.find_by(schedule_id: schedule)
      # Calcular rota usando Mapbox Directions API
      # Suponha que você obtenha a rota na forma de um conjunto de coordenadas
      route_coordinates = [
        [schedule.current_lon, schedule.current_lat],  # Ponto de partida (schedule)
        [emergency.emergency_lon, emergency.emergency_lat]  # Ponto de destino (emergency)
      ]

      routes << route_coordinates
    end

    render json: { routes: routes }
  end


  def create
    @emergency = Emergency.new(emergency_params)
    @emergency.user = current_user
    authorize @emergency
    @chat_response = JSON.parse(
      chatgpt_service("Por favor, avalie a seguinte ocorrência: #{@emergency_description}.
        Forneça uma avaliação da gravidade em uma escala de 0 (menos grave) a 20 (mais grave).
        Para determinar a categoria da ocorrência, atribua o número correspondente à categoria que melhor a descreve, de acordo com as seguintes opções (caso não se enquadre em nenhuma, selecione 'Outros', ou seja, número 11):
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
        A resposta deve ser uma única hash na seguinte estrutura:
        {\"gravidade\":integer, \"numero_pessoas_machucadas\":integer, \"categoria\":integer}.
        Não inclua nenhuma informação adicional além da hash.
        ").call)

    @emergency.gravity = @chat_response["gravidade"]
    @emergency.category = @chat_response["categoria"]
    @emergency.time_start = DateTime.now.to_formatted_s(:db)
    @emergency.save!
    prioritize_emergencies_by_gravity
    find_ambulance(@emergency)

    @chatroom = Chatroom.find(1)
    @message = Message.new(content: @emergency.description)
    @message.chatroom = @chatroom
    @message.user = current_user
    if @message.save
      ChatroomChannel.broadcast_to(
        @chatroom,
        render_to_string(partial: "messages/message", locals: { message: @message })
      )
    end
  end

  def show
    @emergency = Emergency.find(params[:id])
    @lat = @emergency.emergency_lat
    @long = @emergency.emergency_lon
    @schedule = Schedule.find(@emergency.schedule.id)
    @slat = @schedule.current_lon
    @slon = @schedule.current_lat
    authorize @emergency
    @emergencies = Emergency.all
    @emergencies_markers = Emergency.where("id != #{params[:id]}").map do |emergency|
      {
        lat: emergency.emergency_lat,
        lng: emergency.emergency_lon,
        marker_html: render_to_string(partial: "emergency"),
        info_window_html: render_to_string(partial: "info_window", locals: {emergency: emergency})
      }
    end

    @emergency_marker = Emergency.where("id = #{params[:id]}").map do |emergency|
      {
        lat: emergency.emergency_lat,
        lng: emergency.emergency_lon,
        marker_html: render_to_string(partial: "marker"),
        info_window_html: render_to_string(partial: "info_window", locals: {emergency: emergency})
      }
    end

    @schedules_markers = Schedule.where("id = #{@schedule.id}").map do |schedule|
      {
        lat: schedule.current_lat,
        lng: schedule.current_lon,
        marker_html: render_to_string(partial: "schedule_marker"),
        info_window_html: render_to_string(partial: "info_window_schedule", locals: { schedule: schedule })
      }
    end
  end

  def finish
    @emergency = Emergency.find(params[:id])
    schedule = @emergency.schedule
    authorize @emergency
    @emergency.time_end = DateTime.now.to_formatted_s(:db)
    @emergency.end_lat = schedule.current_lat
    @emergency.end_lon = schedule.current_lon
    if @emergency.save
      redirect_to schedule_path(schedule.id)
    else
      render "show", status: :unprocessable_entity
    end
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
    # restringe a procura para somente as ambulancias com emergencias menores que 15 ou menores que a emergencia atual
    emergency.gravity < 15 ? max_gravity = emergency.gravity : max_gravity = 15

    # ambulancias ativas (ambulancias sem emergencias + ambulancias com emergencias < max gravity) considerando apenas as emergencias ativas (time_end = null) (ok)
    @schedules = Schedule.left_joins(:emergencies)
                         .where(active: true)
                         .where('emergencies.gravity < ? OR emergencies.id IS NULL', max_gravity)
                         .joins("LEFT JOIN emergencies ON emergencies.schedule_id = schedules.id AND emergencies.time_end IS NULL")

    # FALTA FAZER caso nao possua ambulancias ativas disponiveis, deverá aguardar uma ambulancia disponivel para rodar o find ambulance, ou seja,
    # toda vez que uma ambulancia receber um time_end, devera rodar um metodo para procurar emergencias sem schedule
    distances = {}
    @schedules.each do |schedule|
      # calcular distancia usando pitagoras ou geocode e colocar em uma hash (ok)
      distances[schedule.id] = calculate_distance(schedule, emergency)
    end
    # lembrar de testar se o autocomplete esta mandando lat e lon com , ou . (ok)
    # acha o id da ambulancia mais proxima
    nearest_ambulance_id = distances.min_by { |id, distance| distance }&.first
    # acha a ambulancia mais proxima
    nearest_ambulance = Schedule.find_by(id: nearest_ambulance_id)

    # oq fazer se nao tiver nenhuma ambulancia
    return if nearest_ambulance.nil?

    # verifica se a ambulancia esta atendendo alguma emergencia
    if check_if_is_free(nearest_ambulance)
      # atribui a ambulancia com a menor distancia a emergencia
      emergency.schedule_id = nearest_ambulance.id
      emergency.start_lon = nearest_ambulance.current_lon
      emergency.start_lat = nearest_ambulance.current_lat
      emergency.save!

      # mandar msg via webhook para o chat das ambulancias
      ChatroomChannel.broadcast_to(
        Chatroom.find(1),
        { type: "emergency", scheduleId: nearest_ambulance.id, emergencyId: emergency.id }
      )
      head :ok
      # FALTA FAZER cria um PopUp na view da central de que foi criada a nova emergencia

    else
      # seleciona a emergencia em andamento da ambulancia proxima que será reatribuida
      emergency_to_be_reattributed = Emergency.where(schedule_id: nearest_ambulance_id, time_end: nil).first
      emergency_to_be_reattributed.schedule_id = nil
      # atribui a ambulancia com a menor distancia a emergencia
      emergency.schedule_id = nearest_ambulance.id
      emergency.schedule_id = nearest_ambulance.id
      emergency.start_lon = nearest_ambulance.current_lon
      emergency.start_lat = nearest_ambulance.current_lat
      emergency.save!
      ChatroomChannel.broadcast_to(
        Chatroom.find(1),
        { type: "emergency", scheduleId: nearest_ambulance.id, emergencyId: emergency.id }
      )
      head :ok
      # FALTA FAZER mandar msg via webhook para o chat das ambulancias
      # FALTA FAZER cria um PopUp na view da central de que a emergencia x da ambulancia reatribuida para a ambulancia x foi criada nova emergencia para amb y
      # se a ambulancia ja possuia uma emergencia em andamento, rodar o metodo find ambulance para a emergencia que ficou sem ambulancia
      find_ambulance(emergency_to_be_reattributed)
    end
  end

  def calculate_distance(schedule, emergency)
    # precisamos colocar latitude e longitude da emergencia e current lat lon para schedule
    Math.sqrt((((schedule.current_lat - emergency.emergency_lat) * 111.11) ** 2) + (((schedule.current_lon - emergency.emergency_lon) * 111.1) ** 2))
  end

  def check_if_is_free(schedule_id)
    # Verifica se não há nenhuma emergency associada à ambulancia ou se há uma emergency com time_end == nil
    Schedule.left_joins(:emergencies)
            .where(id: schedule_id)
            .where("emergencies.id IS NULL OR emergencies.time_end IS NULL")
            .exists?
  end

end
