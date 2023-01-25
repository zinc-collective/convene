class StripeUtilityPolicy < UtilityHookupPolicy
  def permitted_attributes(_params)
    [:name, :api_token]
  end
end
