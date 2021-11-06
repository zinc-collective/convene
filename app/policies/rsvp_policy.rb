# frozen_string_literal: true

class RsvpPolicy < ApplicationPolicy
  alias rsvp object
  delegate :invitation, to: :rsvp
  delegate :space, to: :invitation

  def show?
    true
  end

  # Guests can Rsvp, as can signed-in users.
  def create?
    true
  end

  alias edit? create?
  alias update? create?
  alias destroy? create?
  alias new? create?
end
