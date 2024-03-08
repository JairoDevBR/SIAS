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
    # aqui vamos rodar o geocoding e obter o address limpo
    # aqui vamos rodar o GPT retorna gravidade(prioridade)
    @emergency = Emergency.new(emergency_params)
    @emergency.user = current_user
    authorize @emergency
    # @emergency.schedule = Schedule.where()
    if @emergency.save
      @chat = chatgpt_service("#{@emergency.description}, como voce classificaria a gravidade dessa emergencia de 0(menos grave) a 10(mais grave)?").call
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
    params.require(:emergency).permit(:n_people, :type, :description, :street, :neighborhood, :city)
  end

  def save_without_validation
    save(validate: false)
  end
  # chatgpt
  def chatgpt_service(message)
    ChatgptService.new(message)
  end
end
