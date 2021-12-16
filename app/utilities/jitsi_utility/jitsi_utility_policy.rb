class JitsiUtility < Utility
  class JitsiUtilityPolicy < UtilityPolicy
    def permitted_params
      [:meet_domain]
    end
  end
end