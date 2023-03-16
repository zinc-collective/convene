# frozen_string_literal: true

class UtilityPolicy < ApplicationPolicy
  alias_method :utility, :object

  class Scope < ApplicationScope
    def resolve
      return scope.all if person.operator?

      scope.where(space: person.spaces)
    end
  end

  def show?
    true
  end

  def create?
    return false unless person

    person.member_of?(utility.space) || person.operator?
  end

  def index?
    create?
  end

  def new?
    create?
  end

  def update?
    create?
  end

  def edit?
    create?
  end

  def destroy?
    create?
  end

  def permitted_attributes(params)
    utility_model = Utility.fetch(params[:utility_slug])
    utility_permitted_attributes = if utility_model != Utility
      policy!(utility_model)&.permitted_attributes(params)
    else
      []
    end

    [:name, :utility_slug] + utility_permitted_attributes
  end
end
