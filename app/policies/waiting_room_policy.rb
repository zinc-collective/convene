class WaitingRoomPolicy < ApplicationPolicy
  def show?
    true
  end

  alias_method :update?, :show?
  alias_method :create?, :show?
end
