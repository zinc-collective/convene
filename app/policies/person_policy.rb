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
    [:name, :slug, :blueprint]
  end

  class Scope < ApplicationScope
    def resolve
      return scope.none if person.blank?

      if person.operator?
        scope.all
      else
        scope.where(id: person.id)
      end
    end
  end
end
