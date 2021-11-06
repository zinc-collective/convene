# frozen_string_literal: true

class InvitationPolicy < ApplicationPolicy
  alias invitation object
  delegate :space, to: :invitation

  def show?
    true
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

    # All invitations for an accessible space are visible.
    def resolve
      scope.all
    end
  end
end
