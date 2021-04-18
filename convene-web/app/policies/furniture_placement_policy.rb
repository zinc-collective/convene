class FurniturePlacementPolicy < ApplicationPolicy
  alias furniture_placement object

  def show?
    true
  end

  def update?
    return false unless person

    person.member_of?(furniture_placement.space)
  end

  def edit?
    update?
  end
end
