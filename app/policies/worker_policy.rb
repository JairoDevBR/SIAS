class WorkerPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def index?
    admin?
  end

  def show?
    admin?
  end

  def new?
    admin?
  end

  def create?
    admin?
  end

  def destroy?
    admin?
  end

  def update?
    admin?
  end
  
  private

  def admin?
    user.admin if user.present?
  end
end
