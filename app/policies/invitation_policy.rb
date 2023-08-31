# frozen_string_literal: true

class InvitationPolicy < ApplicationPolicy
  alias_method :invitation, :object
  delegate :space, to: :invitation

  def show?
    true
  end

  def create?
    person&.operator? || person&.member_of?(space)
  end

  alias_method :edit?, :create?
  alias_method :update?, :create?
  alias_method :index?, :create?
  alias_method :destroy?, :create?
  alias_method :new?, :create?

  class Scope < ApplicationScope
    # All invitations for an accessible space are visible.
    def resolve
      if person&.operator?
        scope.all
      else
        scope.where(space: person&.spaces)
      end
    end
  end
end
