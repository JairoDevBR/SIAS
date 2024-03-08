class EmergenciesController < ApplicationController
  before_action :authenticate_user!

  def new
    @emergency = Emergency.new
    authorize @emergency
  end

  def create
    @emergency = Emergency.new(emergency_params)
    authorize @emergency
    @emergency.user = current_user
    # aqui vamos rodar o geocoding e obter o address limpo
    # aqui vamos rodar o GPT retorna gravidade(prioridade)


    # @emergency.schedule = Schedule.where()
    if @emergency.save
      redirect_to new_emergency_path, notice: 'Novo chamado foi criado.'
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
    params.require(:emergency).permit(:description, :street, :neighborhood, :city)
  end

  def save_without_validation
    save(validate: false)
  end
end
