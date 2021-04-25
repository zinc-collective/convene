class UtilityHookupPolicy < ApplicationPolicy
  alias utility_hookup object

  class Scope
    attr_accessor :person, :scope
    def initialize(person, scope)
      @person = person
      @scope = scope
    end

    def resolve
      @scope.where(space: @person.spaces)
    end
  end

  def show?
    true
  end

  def create?
    return false unless person

    person.member_of?(utility_hookup.space)
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
