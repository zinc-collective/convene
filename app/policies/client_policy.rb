class ClientPolicy < ApplicationPolicy
  alias_method :client, :object

  def show?
    true
  end

  def update?
    person.operator?
  end

  alias_method :new?, :update?
  alias_method :edit?, :update?
  alias_method :create?, :update?
  alias_method :destroy?, :update?

  class Scope < ApplicationScope
    def resolve
      scope.all
    end
  end
end
