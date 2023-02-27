# frozen_string_literal: true

class FurniturePlacementPolicy < ApplicationPolicy
  alias_method :furniture_placement, :object
  delegate :space, to: :furniture_placement

  class Scope < ApplicationScope
    def resolve
      room_policy_scope = RoomPolicy::Scope.new(person, Room.all)
      scope.joins(:room).where(room: room_policy_scope.resolve)
    end
  end

  def show?
    true
  end

  def update?
    person&.operator? || person&.member_of?(furniture_placement.space)
  end

  alias_method :edit?, :update?
  alias_method :new?, :update?
  alias_method :create?, :update?
  alias_method :destroy?, :update?

  def permitted_attributes(_params)
    [:furniture_kind, :slot, furniture_attributes: furniture_params]
  end

  def furniture_params
    Furniture::REGISTRY.values.flat_map { |f| f.new.try(:attribute_names) }.compact
  end
end
