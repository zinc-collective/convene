# frozen_string_literal: true

class SpacePolicy < ApplicationPolicy
  alias space object

  def show?
    true
  end

  def update?
    return false unless person

    person.member_of?(space)
  end

  alias new? update?
  alias edit? update?

  def destroy?
    person.operator?
  end

  alias create? destroy?

  def permitted_attributes(_params)
    [:name, :slug, :theme, :blueprint, client_attributes: [:name]]
  end

  class Scope < ApplicationScope
    def resolve
      scope.all
    end
  end
end
