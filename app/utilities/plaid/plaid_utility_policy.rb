module Plaid
  class PlaidUtilityPolicy < UtilityPolicy
    def permitted_attributes(_params)
      %i[environment secret client_id version]
    end
  end
end
