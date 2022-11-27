# frozen_string_literal: true

class Marketplace
  class CartProductPolicy < ApplicationPolicy
    alias cart_product object
    def permitted_attributes(_params = nil)
      %i[quantity product_id]
    end

    def create?
      true
    end

    def update?
      true
    end

    class Scope < ApplicationScope
      def resolve
        scope.all
      end
    end
  end
end
