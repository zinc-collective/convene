# frozen_string_literal: true

class RoomPolicy < ApplicationPolicy
  alias_method :room, :object
  delegate :space, to: :room

  def show?
    return true if room.unlocked? || room.locked?
    return true if room.internal? && person&.member_of?(space)
  end

  def create?
    person&.member_of?(space)
  end

  alias_method :edit?, :create?
  alias_method :update?, :create?
  alias_method :destroy?, :create?
  alias_method :new?, :create?

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
