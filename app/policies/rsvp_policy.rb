# frozen_string_literal: true

class RsvpPolicy < ApplicationPolicy
  alias_method :rsvp, :object
  delegate :invitation, to: :rsvp
  delegate :space, to: :invitation

  def show?
    true
  end

  # Guests can Rsvp, as can signed-in users.
  def create?
    true
  end

  alias_method :edit?, :create?
  alias_method :update?, :create?
  alias_method :destroy?, :create?
  alias_method :new?, :create?
end
