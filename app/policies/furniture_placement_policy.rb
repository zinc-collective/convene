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
      room_policy_scope = RoomPolicy::Scope.new(person, Room.all)
      scope.joins(:room).where(room: room_policy_scope.resolve)
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
