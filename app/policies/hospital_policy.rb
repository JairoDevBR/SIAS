class HospitalPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def obtain_markers?
    central?
  end

  private

  def central?
    user.central == true
  end
end
