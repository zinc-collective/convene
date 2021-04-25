# frozen_string_literal: true

module Utilities
  # Provides Jitsi Video functionality to a {Space}
  # @see https://jitsi.org
  class Jitsi < Utility
    def meet_domain
      configuration.get(:meet_domain)
    end
  end

  class JitsiPolicy < Utility::Policy
    def permitted_params
      [:meet_domain]
    end
  end
end
