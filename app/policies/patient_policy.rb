class PatientPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def new?
    ambulance?
  end

  def create?
    ambulance?
  end

  private

  def ambulance?
    user.central == user.admin
  end
end
