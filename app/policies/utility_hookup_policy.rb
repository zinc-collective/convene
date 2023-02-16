# frozen_string_literal: true

class UtilityHookupPolicy < ApplicationPolicy
  alias_method :utility_hookup, :object

  class Scope < ApplicationScope
    def resolve
      scope.where(space: person.spaces)
    end
  end

  def show?
    true
  end

  def create?
    return false unless person

    person.member_of?(utility_hookup.space)
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
    utility_permitted_attributes =
      policy!(Utilities.fetch(params[:utility_slug]))
        &.permitted_attributes(params)

    [:name, :utility_slug] + utility_permitted_attributes
  end
end
