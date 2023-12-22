# frozen_string_literal: true

class RoomPolicy < ApplicationPolicy
  alias_method :room, :object
  delegate :space, to: :room

  def show?
    return true if room.public?
    true if room.internal? && (person&.member_of?(space) || person&.operator?)
  end

  def create?
    person&.member_of?(space) || person&.operator?
  end

  alias_method :edit?, :create?
  alias_method :update?, :create?
  alias_method :destroy?, :create?
  alias_method :new?, :create?

  def permitted_attributes(params)
    [:access_level, :name, :description, :slug, gizmos_attributes:
       policy(Furniture).permitted_attributes(params)]
  end

  class Scope < ApplicationScope
    def resolve
      if person&.operator?
        scope.all
      elsif person&.authenticated?
        scope.where(space: person.spaces).or(scope.public_access)
      else
        scope.public_access
      end
    end
  end
end
