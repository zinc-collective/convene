# frozen_string_literal: true

module Hookups
  # Provides Jitsi Video functionality to a {Space}
  # @see https://jitsi.org
  class JitsiHookup < Hookup
    def meet_domain
      configuration.get(:meet_domain)
    end
  end

  class JitsiHookupPolicy < ApplicationPolicy
    def permitted_params
      [:meet_domain]
    end
  end
end
