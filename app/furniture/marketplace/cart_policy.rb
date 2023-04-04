# frozen_string_literal: true

class Marketplace
  class CartPolicy < Policy
    alias_method :cart, :object
    class Scope < ApplicationScope
      def resolve
        scope.all
      end
    end
  end
end
