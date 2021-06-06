class FurniturePlacementPolicy < ApplicationPolicy
  alias furniture_placement object
  delegate :space, to: :furniture_placement

  class Scope
    attr_accessor :person, :scope
    def initialize(person, scope)
      @person = person
      @scope = scope
    end

    def resolve
      @scope.joins(:room).where(room: { space: @person.spaces })
    end
  end

  def show?
    true
  end

  def update?
    person&.member_of?(furniture_placement.space)
  end

  alias edit? update?
  alias new? update?
  alias create? update?
  alias destroy? update?
end
