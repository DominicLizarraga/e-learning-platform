class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def edit?
    @user.has_role?(:admin) || @record.user == @user
  end

  def update?
    @user.has_role?(:admin) || @record.user == @user
  end

  def new?
    @user.has_role?(:teacher)
  end

  def show?
    @record.published && @record.approved ||
    @user.present? && @user.has_role?(:admin) ||
    @user.present? && @record.user_id == @user.id ||
    @record.bought(@user)
  end

  def create?
    @user.has_role?(:teacher)
  end

  def destroy?
    @user.has_role?(:admin) || @record.user == @user
  end

  def owner?
    @record.user == @user
  end
end
