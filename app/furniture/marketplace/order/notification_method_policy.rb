class Marketplace
  class Order
    class NotificationMethodPolicy < Policy
      def permitted_attributes(_)
        [:contact_location]
      end

      class Scope < ApplicationScope
        def resolve
          return scope.all if person.operator?

          scope.joins(marketplace: [:room]).where(rooms: {space_id: person.spaces})
        end
      end
    end
  end
end
