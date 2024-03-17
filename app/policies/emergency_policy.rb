class EmergencyPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.where(hospital: user.hospital)
    end
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
    central? || ambulance?
  end

  def obtain_markers_to_emergencies_show?
    ambulance?
  end

  def finish?
    ambulance?
  end

  def obtain_route_to_emergency_show?
    ambulance?
  end

  def obtain_markers_only_current_emergency?
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
