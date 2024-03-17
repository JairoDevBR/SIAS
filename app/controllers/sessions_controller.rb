class SessionsController < Devise::SessionsController
  def destroy
    # logica para atribuir active = false para todas as schedules do mesmo user, com excecao da atual
    # caso o old_schedule tenha uma emergencia ativa, ela precisa receber schedule_id = nil
    old_schedules = Schedule.where(active: true).where(user_id: current_user)
    old_schedules.each do |old_schedule|
      old_schedule.update(active: false)
      if old_schedule.emergencies.exists?(time_end: nil)
        old_schedule.emergencies.where(time_end: nil).update_all(schedule_id: nil)
      end
    end
    # Faça o logout do usuário
    super
  end
end
