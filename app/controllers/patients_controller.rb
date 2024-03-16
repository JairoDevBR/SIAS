class PatientsController < ApplicationController
  def new
    @patient = Patient.new
    authorize @patient
  end

  def create
    @patient = Patient.new(patient_params)
    @emergency = Emergency.find(params[:emergency_id])
    @patient.emergency_id = @emergency
    authorize @patient
    if @patient.save
      redirect_to emergency_path(@emergency)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def patient_params
    params.require(:patient).permit(:gender, :age, :heart_rate, :blood_pressure, :respiratory_rate, :oxygen_saturation, :consciousness, :pain, :gravity, :medical_history, :description)
  end
end
