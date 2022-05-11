module Jitsi
  class JitsiUtilityPolicy < UtilityPolicy
    def permitted_attributes(_params)
      [:meet_domain]
    end
  end
end