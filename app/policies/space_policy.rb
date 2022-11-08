# frozen_string_literal: true

class SpacePolicy < ApplicationPolicy
  alias_method :space, :object

  def show?
    true
  end

  def update?
    return false unless person

    person.member_of?(space)
  end

  alias_method :new?, :update?
  alias_method :edit?, :update?

  def destroy?
    person.operator?
  end

  alias_method :create?, :destroy?

  def permitted_attributes(_params)
    [:name, :slug, :theme, :blueprint, client_attributes: [:name]]
  end

  class Scope < ApplicationScope
    def resolve
      scope.all
    end
  end
end
