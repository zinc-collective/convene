# frozen_string_literal: true

class AuthenticationMethodPolicy < ApplicationPolicy
  alias authentication_method object

  def create?
    person.operator?
  end

  def permit(params)
    params.require(:authentication_method).permit(:contact_method, :contact_location)
  end
end
