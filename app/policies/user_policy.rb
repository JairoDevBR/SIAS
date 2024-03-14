class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all # Allow admins to see all users
      else
        scope.where(id: user.id) # Allow regular users to see only their own user record
      end
    end
  end

  def inicial?
    admin?
  end

  private

  def admin?
    user.admin
  end
end
