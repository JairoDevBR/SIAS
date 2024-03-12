class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :botao]

  def home
  end

  def botao
    skip_authorization
    @schedule = Schedule.find_by(user_id: current_user.id)
    @emergency = Emergency.where(id: @schedule.id).where("emergencies.time_end IS NULL")
  end
end
