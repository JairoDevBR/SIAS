class SchedulesController < ApplicationController
  before_action :authenticate_user!, only: :create

  def index
    @schedules = Schedule.all
    # @schedules = policy_scope(Schedule)
    authorize @schedules
  end

  def show
    @chatroom = Chatroom.find(1)
    @schedule = Schedule.find(params[:id])
    authorize @schedule
  end

  def new
    @schedule = Schedule.new
    @schedule.user = current_user
    # @name = @schedule.worker1.name
    @worker = Worker.new
    authorize @schedule
    @workers = Worker.all
    @login = {}
    @workers.each do |worker|
      @login[worker.id.to_s] = worker.name
    end
    @login = JSON.generate(@login)
  end

  def create
    @schedule = Schedule.new(schedule_params)
    @schedule.user = current_user
    @schedule.active = true
    authorize @schedule
    # logica para atribuir active = false para todas as schedules do mesmo user, com excecao da atual (@schedule ainda nao criada, portando nao precisa de um where.not)
    # caso o old_schedule tenha uma emergencia ativa, ela precisa receber schedule_id = nil
    old_schedules = Schedule.where(active: true).where(user_id: current_user)
    old_schedules.each do |old_schedule|
      old_schedule.update(active: false)
      if old_schedule.emergencies.exists?(time_end: nil)
        old_schedule.emergencies.where(time_end: nil).update_all(schedule_id: nil)
      end
    end
    if @schedule.save!
      redirect_to @schedule, notice: 'Você está logado.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def find_emergency
    schedule_latitude = params[:latitude]
    schedule_longitude = params[:longitude]
    schedule_id = params[:schedule_id]
    distances = {}
    # Verifica se há emergencias acima de 15, nao encerradas e sem atendimento
    if Emergency.where("gravity >= ? AND time_end IS NULL AND schedule_id IS NULL", 15).exists?
      high_gravity_emergencies = Emergency.where("gravity >= ? AND time_end IS NULL", 15)
      high_gravity_emergencies.each do |emergency|
        distances[emergency.id] = calculate_distance(schedule_latitude, schedule_longitude, emergency)
      end
      nearest_high_gravity_emergency_id = distances.min_by { |id, distance| distance }&.first
      nearest_high_gravity_emergency = Emergency.find(nearest_high_gravity_emergency_id)
      raise
      nearest_high_gravity_emergency.schedule_id = schedule_id

      ChatroomChannel.broadcast_to(
        Chatroom.find(1),
        { type: "emergency", scheduleId: schedule_id, emergencyId: nearest_high_gravity_emergency_id }
      )
      head :ok
    end

    # Verifica se há emergencias com gravidade < 15, caso estejam mais proximas do que a ambulancia em andamento
    # Emergency.where()
    # end
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
      # irá retornar apenas a schedule atual
      schedules_markers = Schedule.where(id: params[:schedule_id] , active: true).map do |schedule|
      {
        lat: schedule.current_lat,
        lng: schedule.current_lon,
        marker_html: render_to_string(partial: "schedule_marker"),
        info_window_html: render_to_string(partial: "info_window_schedule", locals: { schedule: schedule, emergency: Emergency.where(schedule_id: schedule, time_end: nil).first })
      }
    end
    render json: { emergencies_markers: emergencies_markers, schedules_markers: schedules_markers }
  end


  def update_location_from_schedules_show_view
    @schedule = Schedule.new
    authorize @schedule
    # id da SCHEDULE (ambulancia)
    id = params[:id]
    # Encontre a instância do modelo
    schedule = Schedule.find(id)
    # Atualize os atributos de latitude e longitude
    schedule.update(current_lat: params[:latitude], current_lon: params[:longitude])
    # Responda com JSON indicando o sucesso
    render json: { message: "Localização atualizada com sucesso" }
  end

  def update_location_from_emergencies_show_view
    @schedule = Schedule.new
    authorize @schedule
    # id da EMERGENCIA
    id = params[:id]
    # Encontre a instância do modelo
    schedule = Schedule.joins(:emergencies).find_by(emergencies: { id: id })
    # Atualize os atributos de latitude e longitude
    schedule.update(current_lat: params[:latitude], current_lon: params[:longitude])
    # Responda com JSON indicando o sucesso
    render json: { message: "Localização atualizada com sucesso" }
  end

  private

  def schedule_params
    params.require(:schedule).permit(:worker1_id, :worker2_id)
  end

  def calculate_distance(schedule_latitude, schedule_longitude, emergency)
    Math.sqrt((((schedule_latitude - emergency.emergency_lat) * 111.11) ** 2) + (((schedule_longitude - emergency.emergency_lon) * 111.1) ** 2))
  end
end
