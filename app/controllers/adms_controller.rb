class AdmsController < ApplicationController
  def inicial
    @adms = policy_scope(User.all)
    authorize current_user
  end
end
