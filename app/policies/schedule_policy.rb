class SchedulePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def new?
    is_ambulance?
  end

  def create?
    is_ambulance?
  end

  private

  def is_ambulance?
    user.admin == user.central
  end
end
