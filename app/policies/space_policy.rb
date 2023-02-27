# frozen_string_literal: true

class SpacePolicy < ApplicationPolicy
  alias_method :space, :object

  def show?
    true
  end

  def update?
    return false unless person

    person.member_of?(space) || person.operator?
  end

  alias_method :edit?, :update?

  def destroy?
    person.operator?
  end

  def new?
    person.authenticated?
  end
  alias_method :create?, :new?

  def permitted_attributes(_params)
    [:name, :slug, :theme, :entrance_id, :blueprint]
  end

  class Scope < ApplicationScope
    def resolve
      scope.all
    end
  end
end
