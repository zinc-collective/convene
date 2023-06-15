class Marketplace
  class Order
    class NotificationMethodPolicy < Policy
      def permitted_attributes(_)
        [:contact_location]
      end
    end
  end
end
