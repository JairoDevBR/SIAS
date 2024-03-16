class SessionsController < Devise::SessionsController
  def destroy
    # Altere o atributo active do modelo Schedule para false quando o usuário faz logout
    current_user.schedules.update_all(active: false)
    # Faça o logout do usuário
    super
  end
end
