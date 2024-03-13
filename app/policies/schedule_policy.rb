class SchedulePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def index?
    ambulance?
  end

  def show?
    ambulance?
  end

  def new?
    ambulance?
  end

  def create?
    ambulance?
  end

  def update_location?
    ambulance?
  end

  private

  def ambulance?
    user.admin == user.central
  end
end
