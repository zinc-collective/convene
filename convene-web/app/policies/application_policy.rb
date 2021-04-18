# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :person, :object

  def initialize(person, object)
    @person = person
    @object = object
  end
end
