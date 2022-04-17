# frozen_string_literal: true

# Parent class for Policies.
# @see https://github.com/varvet/pundit#policies
class ApplicationPolicy
  attr_reader :person, :object

  def initialize(person, object)
    @person = person
    @object = object
  end
end
