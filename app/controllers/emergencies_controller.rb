class EmergenciesController < ApplicationController
  before_action :authenticate_user!

  def new
    @emergency = Emergency.new
  end

  def create
    # precisamos de update? pq quando criamos o emergency, nao teremos todas as informacoes (por exemplo, time_end)
    # definir emergency_params
    @emergency = Emergency.new(emergency_params)
    # mas aqui estaria falando @emergency.user = true/false?
    # current_user.admin.id?
    @emergency.user = current_user.central
    @emergency.schedule = Schedule.where()

    if @emergency.save
      redirect_to new_emergency_path, notice: 'Novo chamado foi criado.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @emergency = Emergency.find(params[:id])
  end

  private

  def emergency_params
    params.require(:emergency).permit(:gravity, :time_start, :time_end, :n_people, :type, :start_lon, :start_lat, :end_lon, :end_lat, :description, :street, :neighborhood, :city, :user_id, :schedule_id)
  end
end
