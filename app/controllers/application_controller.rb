class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  include Pundit::Authorization

  def after_sign_in_path_for(resourse)
    if current_user.admin
      # return home_adm_path

      return home_adm_path
    elsif current_user.central
      return new_emergency_path
    else
      return new_schedule_path
    end
  end

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:admin, :central, :type, :plate])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:admin, :central, :type, :plate])
  end

  # Pundit: allow-list approach
  after_action :verify_authorized, except: [:home, :user_session, :botao], unless: :skip_pundit?
  after_action :verify_policy_scoped, only: [:home, :user_session, :botao], unless: :skip_pundit?

  # # Uncomment when you *really understand* Pundit!
  # # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # # def user_not_authorized
  # #   flash[:alert] = "You are not authorized to perform this action."
  # #   redirect_to(root_path)
  # # end

  # private

  def skip_pundit?
    devise_controller? || (params[:controller] == "pages" && params[:action] == "home") || (params[:controller] == "pages" && params[:action] == "botao")
  end

end
