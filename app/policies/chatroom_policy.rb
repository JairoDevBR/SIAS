class ChatroomPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def show?
    is_ambulance? || is_central?
  end

  private

  def is_ambulance?
    user.central == user.admin
  end

  def is_central?
    user.central
  end
end
