class FurniturePlacementPolicy < ApplicationPolicy
  alias furniture_placement object

  def show?
    true
  end

  def update?
    return false unless person

    person.member_of?(furniture_placement.space)
  end

  alias edit? update?
  alias new? update?
  alias create? update?
  alias destroy? update?
end
