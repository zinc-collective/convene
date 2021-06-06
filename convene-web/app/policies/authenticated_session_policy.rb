# frozen_string_literal: true

class AuthenticatedSessionPolicy < ApplicationPolicy
  # @return [AuthenticatedSession]
  alias authenticated_session object

  def new?
    true
  end

  alias create? new?

  def show?
    authenticated_session.person == person
  end

  alias update? show?
  alias destroy? show?
  alias create? show?


end