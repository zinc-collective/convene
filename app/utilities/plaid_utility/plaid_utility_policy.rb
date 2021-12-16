class PlaidUtility < Utility
  class PlaidUtilityPolicy < UtilityPolicy
    def permitted_params
      %i[environment secret client_id version]
    end
  end
end
