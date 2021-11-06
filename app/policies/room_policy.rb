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

  class Scope
    attr_accessor :actor, :scope

    def initialize(actor, scope)
      self.actor = actor
      self.scope = scope
    end

    def resolve
      scope.accessable_by(actor)
    end
  end
end
