# frozen_string_literal: true

class Marketplace
  class CartPolicy < ApplicationPolicy
    alias_method :cart, :object
    def permitted_attributes(_params = nil)
      %i[delivery_address]
    end

    def create?
      true
    end

    def update?
      cart.shopper.person.nil? || cart.shopper.person == current_person
    end

    class Scope < ApplicationScope
      def resolve
        scope.all
      end
    end
  end
end
