# frozen_string_literal: true

class Marketplace
  class OrderPolicy < Policy
    class Scope
      attr_accessor :scope, :shopper
      delegate :person, to: :shopper

      def initialize(shopper, scope)
        self.scope = scope
        self.shopper = shopper
      end

      def resolve
        return scope.all if person&.operator?

        scope.joins(marketplace: [:room]).where(rooms: {space_id: person&.spaces})
          .or(scope.where(shopper: shopper))
      end
    end
  end
end
