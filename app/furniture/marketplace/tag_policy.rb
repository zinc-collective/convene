# frozen_string_literal: true

class Marketplace
  class TagPolicy < Policy
    alias_method :tag, :object
    def space
      tag.bazaar
    end

    def permitted_attributes(_params = nil)
      %i[label]
    end

    def update?
      return false unless current_person.authenticated?

      super
    end

    alias_method :create?, :update?

    def show?
      true
    end

    class Scope < ApplicationScope
      def resolve
        scope.all
      end
    end
  end
end
