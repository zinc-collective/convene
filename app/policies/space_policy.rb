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

  class Scope < ApplicationScope
    def resolve
      scope.all
    end
  end
end
