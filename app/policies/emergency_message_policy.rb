class EmergencyMessagePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def create?
    is_ambulance? || is_central? || is_hospital?
  end

  private

  def is_ambulance?
    user.central == user.admin
  end

  def is_central?
    user.central
  end

  def is_hospital?
    user.hospital
  end
end
