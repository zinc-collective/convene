# frozen_string_literal: true

class PersonPolicy < ApplicationPolicy
  alias_method :person, :object

  def show?
    current_person == person || current_person.operator?
  end

  alias_method :new?, :show?
  alias_method :update?, :show?
  alias_method :edit?, :show?
  alias_method :destroy?, :show?
  alias_method :create?, :show?

  def permitted_attributes(_params)
    [:name, :slug, :theme, :blueprint]
  end

  class Scope < ApplicationScope
    def resolve
      scope.all
    end
  end
end
