# frozen_string_literal: true

require_relative 'hookups/hookup'
require_relative 'hookups/plaid_hookup'
require_relative 'hookups/jitsi_hookup'

# {Hookups} allow external services to provide functionality to a {Space} and
# its {Furniture}.
#
# Every {Space} can have {SpaceHookup}s that securely store API keys and other
# configuration for the {Hookup} to work with the {Space}.
#
# @see features/hookups.feature
# @see features/hookups/
module Hookups
  REGISTRY = {
    plaid: PlaidHookup,
    jitsi: JitsiHookup
  }.freeze

  # @param space_hookup [SpaceHookup]
  # @return [Hookup]
  def self.from_space_hookup(space_hookup)
    REGISTRY.fetch(space_hookup.hookup_slug&.to_sym, NullHookup).new(space_hookup: space_hookup)
  end

  class NullHookup < Hookup
  end
end
