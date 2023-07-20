# frozen_string_literal: true

class Marketplace
  class OrderPolicy < Policy
    class Scope < ApplicationScope
      def resolve
        return scope.all if person.operator?

        if person.authenticated?
          scope.where(rooms: {space_id: person.spaces})
            .or(scope.where(shopper: Shopper.where(person: person)))
        else
          scope.where(shopper: Shopper.where(person: nil))
            .where("marketplace_orders.created_at > ?", 1.week.ago)
        end.joins(marketplace: [:room])
      end
    end
  end
end
