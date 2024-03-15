class EmergencyPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def new?
    central?
  end

  def create?
    central?
  end

  def show?
    ambulance?
  end

  def obtain_routes?
    central?
  end

  def obtain_markers?
    central?
  end

  def finish?
    ambulance?
  end

  private

  def central?
    user.central == true
  end

  def ambulance?
    user.central == user.admin
  end
end
