# frozen_string_literal: true

# Parent class for Policies.
# @see https://github.com/varvet/pundit#policies
class ApplicationPolicy
  attr_reader :current_person, :object
  alias_method :person, :current_person

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

  def show?
    update?
  end

  def initialize(current_person, object)
    @current_person = current_person
    @object = object
  end

  def permit(params)
    params.permit(permitted_attributes(params))
  end

  def permitted_attributes(_params)
    raise NotImplementedError
  end

  def policy(object)
    Pundit.policy(current_person, object)
  end

  def policy!(object)
    Pundit.policy!(current_person, object)
  end
end
