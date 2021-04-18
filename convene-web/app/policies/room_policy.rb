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
end
