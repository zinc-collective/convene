class ClientPolicy < ApplicationPolicy
  alias client object

  def show?
    true
  end

  def update?
    person.operator?
  end

  alias new? update?
  alias edit? update?
  alias create? update?
  alias destroy? update?

  class Scope < ApplicationScope
    def resolve
      scope.all
    end
  end
end
