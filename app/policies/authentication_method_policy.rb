class AuthenticationMethodPolicy < ApplicationPolicy
  alias authentication_method object

  def create?
    person.operator?
  end
end
