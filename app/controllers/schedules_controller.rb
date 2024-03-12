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
    # criacao dos markers de emergencias
    @emergencies = Emergency.all
    @markers = []
    @markers = @emergencies.map do |emergency|
      {
        lat: emergency.emergency_lat,
        lng: emergency.emergency_lon,
        marker_html: render_to_string(partial: "marker")
      }
    end
  end

  def new
    @schedule = Schedule.new
    @schedule.user = current_user
    # @name = @schedule.worker1.name
    @worker = Worker.new
    authorize @schedule
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

  private

  def schedule_params
    params.require(:schedule).permit(:worker1_id, :worker2_id)
  end
end
