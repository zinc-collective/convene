# frozen_string_literal: true

# Parent class for Policies.
# @see https://github.com/varvet/pundit#policies
class ApplicationPolicy
  attr_reader :person, :object

  def create?
    raise NotImplementedError
  end

  def new?
    create?
  end

  def update?
    raise NotImplementedError
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  def index?
    true
  end

  def initialize(person, object)
    @person = person
    @object = object
  end

  def current_person
    @person
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

  def policy!(object)
    Pundit.policy!(person, object)
  end
end
