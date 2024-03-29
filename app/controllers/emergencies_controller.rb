require 'json'
require 'date'

class EmergenciesController < ApplicationController
  before_action :authenticate_user!

  def index
    @emergencies = policy_scope(Emergency)
  end

  def new
    @emergency = Emergency.new
    authorize @emergency
  end

  def create
    @emergency = Emergency.new(emergency_params)
    @emergency.user = current_user
    authorize @emergency
    @chat_response = JSON.parse(
      chatgpt_service("Por favor, avalie a seguinte ocorrência: #{@emergency.description}.
        Forneça uma avaliação da gravidade em uma escala de 0 (menos grave) a 20 (mais grave).
        Para a descrição, reescreva a emergência sem acrescentar ou remover informações, porém de forma clara e sucinta e obrigatoriamente com mais de 80 caracteres.
        Informe também o número de pessoas machucadas.
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
        Forneça de forma resumida e com até 50 caracteres recomedação/recomendações para a equipe de socorrista do que já deixar preparado para a ocorrência descrita.
        A resposta deve ser uma única hash na seguinte estrutura:
        {\"gravidade\":integer, \"descricao\":string, \"numero_pessoas_machucadas\":integer, \"categoria\":integer, \"recomendacao\":string}.
        Não inclua nenhuma informação adicional além da hash.
        Sempre retorne no formato solicitado e não retorne erro.
        ").call)

    @emergency.gravity = @chat_response["gravidade"]
    @emergency.description = @chat_response["descricao"]
    @emergency.category = @chat_response["categoria"]
    @recomendation = @chat_response["recomendacao"]
    @emergency.time_start = DateTime.now.to_formatted_s(:db)
    if @emergency.save
      find_ambulance(@emergency, @recomendation)
      # find_hospital(@emergency)
      send_to_all_chat(@emergency, @recomendation)
    else
      p "#{@emergency.errors.messages}"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @emergency = Emergency.find(params[:id])
    authorize @emergency
    @schedule = Schedule.find(@emergency.schedule.id)
    @chat = Chat.find(@emergency.chat_id)
    @post = Post.new
    @post.chat = @chat
    @post.user = current_user
    @patient = Patient.new
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

  # >>>>>>>>>>>>>>>>>>>> AJAX ENDPOINTS <<<<<<<<<<<<<<<<<<<<<<

  # endpoint for Mapbox's markers to the central view
  def obtain_markers
    # pundit authorizations
    authorize Emergency.new
    authorize Schedule.new
    authorize Hospital.new

    # markers for not finished emergencies
    emergencies_markers = Emergency.where(time_end: nil).map do |emergency|
      {
        lat: emergency.emergency_lat,
        lng: emergency.emergency_lon,
        marker_html: render_to_string(partial: "emergency"),
        info_window_html: render_to_string(partial: "info_window", locals: { emergency: emergency }),
      }
    end

    # markers for active ambulances
    schedules_markers = Schedule.where(active: true).map do |schedule|
      {
        lat: schedule.current_lat,
        lng: schedule.current_lon,
        marker_html: render_to_string(partial: "schedule_marker"),
        # since each schedule can have more than one emergency, only the unfinished emergency is filtered
        info_window_html: render_to_string(partial: "info_window_schedule", locals: { schedule: schedule, emergency: Emergency.where(schedule_id: schedule, time_end: nil).first })
      }
    end

    # markers for hospitals
    hospitals_markers = Hospital.all.map do |hospital|
      {
        lat: hospital.latitude,
        lng: hospital.longitude,
        marker_html: render_to_string(partial: "hospital_marker"),
        info_window_html: render_to_string(partial: "info_window_hospital", locals: { hospital: hospital })
      }
    end
    render json: { emergencies_markers: emergencies_markers, schedules_markers: schedules_markers, hospitals_markers: hospitals_markers }
  end

  # endpoint for Mapbox's markers from the ambulance view when she already has an emergency
  def obtain_markers_to_emergencies_show
    authorize Emergency.new
    authorize Schedule.new

    # markers for not finished emergencies
    emergencies_markers = Emergency.where(time_end: nil).map do |emergency|
      {
        lat: emergency.emergency_lat,
        lng: emergency.emergency_lon,
        marker_html: render_to_string(partial: "emergency"),
        info_window_html: render_to_string(partial: "info_window", locals: { emergency: emergency }),
      }
    end

    # marker for the active ambulance from the param ID
    schedules_markers = Schedule.joins(:emergencies).where(active: true, emergencies: { id: params[:emergency_id]}).map do |schedule|
      {
        lat: schedule.current_lat,
        lng: schedule.current_lon,
        marker_html: render_to_string(partial: "schedule_marker"),
        # nao estou conseguindo enviar a variavel local emergency para o popup -> problema com o locals ou partials?
        info_window_html: render_to_string(partial: "info_window_schedule", locals: { schedule: schedule, emergency: Emergency.find_by(id: params[:emergency_id]) })
      }
    end
    render json: { emergencies_markers: emergencies_markers, schedules_markers: schedules_markers }
  end

  # endpoint for Mapbox's marker to fit the borders on the current ambulance and the current emergency
  def obtain_markers_only_current_emergency
    authorize Emergency.new
    authorize Schedule.new

    # marker for the active emergency from the param ID
    emergencies_markers = Emergency.where(id: params[:emergency_id]).map do |emergency|
      {
        lat: emergency.emergency_lat,
        lng: emergency.emergency_lon,
        marker_html: render_to_string(partial: "emergency"),
        info_window_html: render_to_string(partial: "info_window", locals: { emergency: emergency }),
      }
    end

    # marker for the active ambulance which is chasing the ambulance from the param ID
    schedules_markers = Schedule.joins(:emergencies).where(active: true, emergencies: { id: params[:emergency_id]}).map do |schedule|
      {
        lat: schedule.current_lat,
        lng: schedule.current_lon,
        marker_html: render_to_string(partial: "schedule_marker"),
        # nao estou conseguindo enviar a variavel local emergency para o popup
        info_window_html: render_to_string(partial: "info_window_schedule", locals: { schedule: schedule, emergency: Emergency.find_by(id: params[:emergency_id]) })
      }
    end
    render json: { emergencies_markers: emergencies_markers, schedules_markers: schedules_markers }
  end

  # endpoint for Mapbox's routes to the central view
  def obtain_routes
    authorize Schedule.new
    authorize Emergency.new
    routes = [] # not necessary, but it's a good practice to declare explicitly
    # select all ambulances that have an ongoing emergency
    schedules = Schedule.joins(:emergencies).where(emergencies: { time_end: nil })
    schedules.each do |schedule|
      emergency = Emergency.find_by(schedule_id: schedule)
      route_coordinates = [
        [schedule.current_lon, schedule.current_lat],  # Start point (schedule)
        [emergency.emergency_lon, emergency.emergency_lat]  # End point (emergency)
      ]
      # creates an array of start and end coordinates for each ongoing route
      routes << route_coordinates
    end

    render json: { routes: routes }
  end

  # endpoint for Mapbox's route to the ambulance view after having an emergency assigned
  def obtain_route_to_emergency_show
    emergency = Emergency.find(params[:emergency_id])
    authorize emergency
    schedule = Schedule.joins(:emergencies).where(emergencies: emergency).first
    authorize schedule
    routes = []
    route_coordinates = [
      [schedule.current_lon, schedule.current_lat],  # Start point (schedule)
      [emergency.emergency_lon, emergency.emergency_lat]  # End point (emergency)
    ]
    # creates an array of start and end coordinates for the ongoing route
    routes << route_coordinates

    render json: { routes: routes }
  end

  # >>>>>>>>>>>>>>>>>>>> AJAX ENDPOINTS END <<<<<<<<<<<<<<<<<<<<<<

  private

  def patient_params
    params.require(:patient).permit(:heart_rate, :blood_pressure, :respiratory_rate, :oxygen_saturation, :consciousness, :pain, :medical_history, :description)
  end

  def emergency_params
    params.require(:emergency).permit(:description, :n_people, :street, :neighborhood, :city, :local_type, :emergency_lat, :emergency_lon)
  end

  def chatroom_params
    params.require(:chatroom).permit(:description, :n_people, :street, :neighborhood, :city, :local_type, :emergency_lat, :emergency_lon)
  end

  def save_without_validation
    save(validate: false)
  end

  # chatgpt
  def chatgpt_service(message)
    ChatgptService.new(message)
  end

  def find_ambulance(emergency, recomendation)
    # restrict the search to only ambulances with emergencies less than 15 or less than the current emergency
    emergency.gravity < 15 ? max_gravity = emergency.gravity : max_gravity = 15

    # active ambulances (ambulances without emergencies + ambulances with emergencies < max gravity) considering only active emergencies (time_end = null)
    @schedules = Schedule.left_joins(:emergencies)
                         .where(active: true)
                         .where('emergencies.gravity < ? OR emergencies.id IS NULL', max_gravity)
                         .joins("LEFT JOIN emergencies ON emergencies.schedule_id = schedules.id AND emergencies.time_end IS NULL")
                         .distinct
    # FALTA FAZER sempre que uma ambulancia encerrar uma chamada, rodar o find ambulance
    distances = {}
    @schedules.each do |schedule|
      # calculate distance using pythagoras and place it in a hash
      distances[schedule.id] = calculate_distance(schedule, emergency)
    end
    # find the nearest ambulance
    nearest_ambulance_id = distances.min_by { |id, distance| distance }&.first
    nearest_ambulance = Schedule.find_by(id: nearest_ambulance_id)

    # return nil if there are no ambulances available
    return if nearest_ambulance.nil?

    # if the nearest ambulance is not attending to an emergency, it receives the emergency
    if check_if_is_free(nearest_ambulance)
      emergency.schedule_id = nearest_ambulance.id
      emergency.start_lon = nearest_ambulance.current_lon
      emergency.start_lat = nearest_ambulance.current_lat
      send_to_emergency(emergency, recomendation)
      emergency.save!

      # send the information related to the emergency via webhook to the ambulance chat
      ChatroomChannel.broadcast_to(
        Chatroom.find(1),
        { type: "emergency", scheduleId: nearest_ambulance.id, emergencyId: emergency.id }
      )
      head :ok
      # FALTA FAZER cria um PopUp na view da central de que foi criada a nova emergencia

    else
      # if the nearest ambulance is already attending to an emergency, save its emergency in a variable
      emergency_to_be_reattributed = Emergency.where(schedule_id: nearest_ambulance_id, time_end: nil).first
      # remove the ambulance that was attending and wait for another ambulance
      emergency_to_be_reattributed.schedule_id = nil

      # the ambulance receives the newly created emergency
      emergency.schedule_id = nearest_ambulance.id
      emergency.start_lon = nearest_ambulance.current_lon
      emergency.start_lat = nearest_ambulance.current_lat
      send_to_emergency(emergency, recomendation)
      emergency.save!

      # send the information related to the emergency via webhook to the ambulance chat
      ChatroomChannel.broadcast_to(
        Chatroom.find(1),
        { type: "emergency", scheduleId: nearest_ambulance.id, emergencyId: emergency.id }
      )
      head :ok
      # FALTA FAZER cria um PopUp na view da central de que a emergencia x da ambulancia reatribuida para a ambulancia x foi criada nova emergencia para amb y
      # se a ambulancia ja possuia uma emergencia em andamento, rodar o metodo find ambulance para a emergencia que ficou sem ambulancia

      # recursively run the find ambulance method with the emergency that was removed from the ambulance
      find_ambulance(emergency_to_be_reattributed)
    end
  end

  # calculate distance using pythagoras
  def calculate_distance(schedule, emergency)
    Math.sqrt((((schedule.current_lat - emergency.emergency_lat) * 111.11) ** 2) + (((schedule.current_lon - emergency.emergency_lon) * 111.1) ** 2))
  end

  # return true or false if the ambulance is not attending to an emergency
  def check_if_is_free(schedule_id)
    Schedule.left_joins(:emergencies)
            .where(id: schedule_id)
            .where("emergencies.id IS NULL OR emergencies.time_end IS NULL")
            .exists?
  end

  # def find_hospital(emergency)
  #   @hospitals = Hospital.all

  #   distances = {}
  #   @hospitals.each do |hospital|
  #     distances[hospital.id] = calculate_distance_hospital(hospital, emergency)
  #   end
  #   nearest_hospital_id = distances.min_by { |id, distance| distance }&.first
  #   nearest_hospital = Hospital.find_by(id: nearest_hospital_id)

  #   emergency.hospital_id = nearest_hospital.id
  #   emergency.save!

  # end

  def calculate_distance_hospital(hospital, emergency)
    Math.sqrt((((hospital.latitude - emergency.emergency_lat) * 111.11) ** 2) + (((hospital.longitude - emergency.emergency_lon) * 111.1) ** 2))
  end

  # colocar no content da msg a descricao, gravidade, recomendacao
  def send_to_all_chat(emergency, recomendation)
    msg = "Ocorrência nº#{emergency.id}: #{emergency.description}
    Gravidade: #{emergency.gravity} => Recomendação: #{recomendation}"
    @chatroom = Chatroom.find(1)
    @message = Message.new(content: msg)
    @message.chatroom = @chatroom
    @message.user = current_user
    if @message.save
      ChatroomChannel.broadcast_to(
        @chatroom,
        render_to_string(partial: "messages/message", locals: { message: @message })
      )
    end
  end

  def send_to_emergency(emergency, recomendation)
    chat = Chat.create(name: "Ocorrência nº#{emergency.id}")
    emergency.chat = chat
    msg = "Ocorrência nº#{emergency.id}: #{emergency.description}
    Gravidade: #{emergency.gravity} => Recomendação: #{recomendation}"
    post = Post.new(content: msg)
    post.chat = chat
    post.user = current_user
    if post.save
      ChatChannel.broadcast_to(
        chat,
        render_to_string(partial: "post", locals: {post: post})
      )
      head :ok
    else
      render "chats/show", status: :unprocessable_entity
    end
  end
end
