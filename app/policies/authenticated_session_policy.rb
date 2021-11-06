# frozen_string_literal: true

class AuthenticatedSessionPolicy < ApplicationPolicy
  # @return [AuthenticatedSession]
  alias authenticated_session object

  def new?
    true
  end

  def show?
    true
  end

  alias update? show?
  alias destroy? show?
  alias create? new?
end
