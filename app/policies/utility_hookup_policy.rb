class UtilityHookupPolicy < ApplicationPolicy
  alias utility_hookup object

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
end
