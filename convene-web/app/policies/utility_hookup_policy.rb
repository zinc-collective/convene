class UtilityHookupPolicy < ApplicationPolicy
  alias utility_hookup object

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
