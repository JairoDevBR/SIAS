class EmergencyPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def new?
    is_central?
  end

  def create?
    is_central?
  end

  def show?
    is_ambulance?
  end

  def finish?
    is_ambulance?
  end

  private

  def is_central?
    user.central == true
  end

  def is_ambulance?
    user.central == user.admin
  end
end
