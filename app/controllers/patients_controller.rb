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
    message = "Idade: #{@patient.age}\nGênero: #{@patient.gender}\nFrequência cardíaca: #{@patient.heart_rate}\n
    Frequência respiratória: #{@patient.respiratory_rate}\n
    Pressão arterial: #{@patient.blood_pressure}\n
    Saturação de oxigênio: #{@patient.oxygen_saturation}\n
    Nível de consciência: #{@patient.consciousness}\n
    Escala de dor: #{@patient.pain}\n
    Gravidade: #{@patient.gravity}\n
    Histórico médico: #{@patient.medical_history}\n
    Descrição: #{@patient.description}"
    @chat = Chat.find(@emergency.chat_id)
    @emergency.chat = @chat
    @post = Post.new(content: message)
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
