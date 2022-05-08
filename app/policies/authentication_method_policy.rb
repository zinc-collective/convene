# frozen_string_literal: true

class AuthenticationMethodPolicy < ApplicationPolicy
  alias authentication_method object

  def create?
    person.operator?
  end

  def permitted_attributes(_params)
    [:contact_method, :contact_location]
  end
end
