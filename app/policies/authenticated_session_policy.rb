# frozen_string_literal: true

class AuthenticatedSessionPolicy < ApplicationPolicy
  # @return [AuthenticatedSession]
  alias_method :authenticated_session, :object

  def new?
    true
  end

  def show?
    true
  end

  alias_method :update?, :show?
  alias_method :destroy?, :show?
  alias_method :create?, :new?
end
