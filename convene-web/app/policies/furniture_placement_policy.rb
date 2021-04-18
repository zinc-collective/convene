class FurniturePlacementPolicy < ApplicationPolicy
  attr_reader :person, :furniture_placement

  def initialize(person, furniture_placement)
    @person = person
    @furniture_placement = furniture_placement
  end

  def update?
    person.member_of?(furniture_placement.space)
  end

  def edit?
    update?
  end
end
