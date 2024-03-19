class PatientsController < ApplicationController
  before_action :set_emergency

  def new
    @patient = Patient.new
    authorize @patient
  end

  def create
    @patient = Patient.new(patient_params)
    @patient.emergency = @emergency
    authorize @patient
    @patient.save
    message = "<strong>Idade:</strong> #{@patient.age}<br>
    <strong>Gênero:</strong> #{@patient.gender}<br>
    <strong>Frequência cardíaca:</strong> #{@patient.heart_rate}<br>
    <strong>Frequência respiratória:</strong> #{@patient.respiratory_rate}<br>
    <strong>Pressão arterial:</strong> #{@patient.blood_pressure}<br>
    <strong>Saturação de oxigênio:</strong> #{@patient.oxygen_saturation}<br>
    <strong>Nível de consciência:</strong> #{@patient.consciousness}<br>
    <strong>Escala de dor:</strong> #{@patient.pain}<br>
    <strong>Gravidade:</strong> #{@patient.gravity}<br>
    <strong>Histórico médico:</strong> #{@patient.medical_history}<br>
    <strong>Descrição:</strong> #{@patient.description}"

    @chat = Chat.find(@emergency.chat_id)
    @emergency.chat = @chat
    @post = Post.new(content: message.html_safe)
    @post.chat = @chat
    @post.user = current_user
    if @post.save
      ChatChannel.broadcast_to(
        @chat,
        render_to_string(partial: "post", locals: {post: @post})
      )
      head :ok
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def set_emergency
    @emergency = Emergency.find(params[:emergency_id])
  end

  def patient_params
    params.require(:patient).permit(:gender, :age, :heart_rate, :blood_pressure, :respiratory_rate, :oxygen_saturation, :consciousness, :pain, :gravity, :medical_history, :description)
  end
end
