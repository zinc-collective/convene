class ApplicationScope
  attr_accessor :person, :scope

  def initialize(person, scope)
    @person = person
    @scope = scope
  end

  def resolve
    scope.none
  end
end
