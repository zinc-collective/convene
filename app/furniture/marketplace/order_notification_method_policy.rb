class Marketplace
  class OrderNotificationMethodPolicy < Policy
    def permitted_attributes(_)
      [:contact_location]
    end
  end
end
