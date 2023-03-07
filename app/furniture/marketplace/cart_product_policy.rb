# frozen_string_literal: true

class Marketplace
  class CartProductPolicy < Policy
    def permitted_attributes(_params = nil)
      %i[quantity product_id]
    end

    class Scope < ApplicationScope
      def resolve
        scope.all
      end
    end
  end
end
