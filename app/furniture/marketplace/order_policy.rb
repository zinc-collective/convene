# frozen_string_literal: true

class Marketplace
  class OrderPolicy < CheckoutPolicy
    alias_method :order, :object

    def show?
      create?
    end

    class Scope < ApplicationScope
      def resolve
        scope.all
      end
    end
  end
end
