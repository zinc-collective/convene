# frozen_string_literal: true

# Parent class for Policies.
# @see https://github.com/varvet/pundit#policies
class ApplicationPolicy
  attr_reader :person, :object

  def initialize(person, object)
    @person = person
    @object = object
  end

  def permit(params)
    params.permit(permitted_attributes(params))
  end

  def permitted_attributes(_params)
    raise NotImplementedError
  end

  def policy(object)
    Pundit.policy(person, object)
  end
end
