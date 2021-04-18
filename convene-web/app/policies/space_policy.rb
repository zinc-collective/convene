class SpacePolicy < ApplicationPolicy
  attr_reader :person, :space

  def initialize(person, space)
    @person = person
    @space = space
  end

  def update?
    person.member_of?(space)
  end

  def edit?
    update?
  end
end
