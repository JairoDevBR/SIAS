class ChatPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def new?
    ambulance? || central?
  end

  def show?
    ambulance? || central?
  end

  private

  def ambulance?
    user.central == user.admin
  end

  def central?
    user.central
  end

end
