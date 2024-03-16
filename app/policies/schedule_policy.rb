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

  def update_location_from_emergencies_show_view?
    ambulance?
  end

  def update_location_from_schedules_show_view?
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

  def obtain_route_to_emergency_show?
    ambulance?
  end

  def obtain_markers_only_current_emergency?
    ambulance?
  end


  private

  def ambulance?
    user.admin == user.central
  end

  def central?
    user.central == true
  end
end
