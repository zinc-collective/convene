# frozen_string_literal: true

class Marketplace
  class Cart
    class DeliveryPolicy < Policy
      alias_method :delivery, :object
      def permitted_attributes(_params = nil)
        %i[delivery_address contact_email contact_phone_number delivery_window delivery_area_id]
      end

      class Scope < ApplicationScope
        def resolve
          scope.all
        end
      end
    end
  end
end
