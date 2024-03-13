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
    @emergencies = Emergency.all
    @markers = []
    @markers = @emergencies.map do |emergency|
      {
        lat: emergency.emergency_lat,
        lng: emergency.emergency_lon,
        marker_html: render_to_string(partial: "emergency"),
        info_window_html: render_to_string(partial: "info_window", locals: {emergency: emergency})
      }
    end
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
    if @schedule.save!
      redirect_to schedule_path(@schedule), notice: 'Você está logado.'
    else
      render :new, status: :unprocessable_entity
    end
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

  def update_location_from_schedules_show_view
    @schedule = Schedule.new
    authorize @schedule
    # id da SCHEDULE (ambulancia)
    id = params[:id]
    # Encontre a instância do modelo
    schedule = Schedule.find_by(id)
    # Atualize os atributos de latitude e longitude
    schedule.update(current_lat: params[:latitude], current_lon: params[:longitude])
    # Responda com JSON indicando o sucesso
    render json: { message: "Localização atualizada com sucesso" }
  end

  private

  def schedule_params
    params.require(:schedule).permit(:worker1_id, :worker2_id)
  end
end
