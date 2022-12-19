class StripeUtility < UtilityHookup
  class Policy < UtilityHookupPolicy
    def permitted_attributes(_params)
      [:name, :api_token]
    end
  end
end
