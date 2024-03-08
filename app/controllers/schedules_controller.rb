class SchedulesController < ApplicationController
  before_action :authenticate_user!, only: :create

  def index
    @schedules = Schedule.all
    # @schedules = policy_scope(Schedule)
    authorize @schedules
  end

  def new
    @schedule = Schedule.new
    @schedule.user = current_user
    authorize @schedule
  end

  def create
    @schedule = Schedule.new(schedule_params)
    @schedule.user = current_user
    @schedule.active = true
    authorize @schedule
    if @schedule.save!
      redirect_to schedules_path, notice: 'Você está logado.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def schedule_params
    params.require(:schedule).permit(:worker1_id, :worker2_id)
  end
end
