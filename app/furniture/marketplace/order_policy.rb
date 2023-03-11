# frozen_string_literal: true

class Marketplace
  class OrderPolicy < Policy
    class Scope < ApplicationScope
      def resolve
        return scope.all if person.operator?

        scope.joins(marketplace: [:room]).where(rooms: {space_id: person.spaces})
          .or(scope.where(shopper: Shopper.where(person: person)))
      end
    end
  end
end
