class PostPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def create?
    central? || ambulance?
  end

  private

  def ambulance?
    user.admin == user.central
  end

  def central?
    user.central
  end
end
