# frozen_string_literal: true

# Provides Jitsi Video functionality to a {Space}
# @see https://jitsi.org
class JitsiUtility < Utility
  def meet_domain
    configuration['meet_domain']
  end

  def meet_domain=(value)
    configuration['meet_domain'] = value
  end

  def attribute_names
    super + [:meet_domain]
  end
end

class JitsiUtilityPolicy < Utility::Policy
  def permitted_params
    [:meet_domain]
  end
end
