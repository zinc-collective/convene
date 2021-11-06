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

  class Scope
    attr_accessor :actor, :scope

    def initialize(actor, scope)
      @actor = actor
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
