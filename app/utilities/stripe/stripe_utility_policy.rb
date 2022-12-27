module Stripe
  class StripeUtilityPolicy < UtilityPolicy
    def permitted_attributes(_params)
      [:name, :api_token]
    end
  end
end
