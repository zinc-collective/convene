# frozen_string_literal: true

class RoomPolicy < ApplicationPolicy
  alias room object
  delegate :space, to: :room

  def show?
    return true if room.unlocked? || room.locked?
    return true if room.internal? && person&.member_of?(space)
  end

  def create?
    person&.member_of?(space)
  end

  alias edit? create?
  alias update? create?
  alias destroy? create?
  alias new? create?

  def permitted_attributes(params)
    [:access_level, :access_code, :name, :slug, :publicity_level,
     furniture_placements_attributes:
      policy(FurniturePlacement).permitted_attributes(params)]
  end

  class Scope < ApplicationScope
    def resolve
      scope.all
    end
  end
end
