# frozen_string_literal: true

class RsvpPolicy < ApplicationPolicy
  alias_method :rsvp, :object
  delegate :invitation, to: :rsvp
  delegate :space, to: :invitation

  def show?
    true
  end

  # Anyone with an RSVP link can RSVP
  def create?
    true
  end

  alias_method :edit?, :create?
  alias_method :update?, :create?
  alias_method :destroy?, :create?
  alias_method :new?, :create?
end
