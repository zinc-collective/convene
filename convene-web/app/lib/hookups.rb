# frozen_string_literal: true

require_relative 'hookups/hookup'
require_relative 'hookups/plaid_hookup'
require_relative 'hookups/jitsi_hookup'

# {Hookups} allow external services to provide functionality to a {Space} and
# its {Furniture}.
#
# Every {Space} can have {UtilityHookup}s that securely store API keys and other
# configuration for the {Hookup} to work with the {Space}.
#
# @see features/hookups.feature
# @see features/hookups/
module Hookups
  REGISTRY = {
    plaid: PlaidHookup,
    jitsi: JitsiHookup
  }.freeze

  # @param utility_hookup [UtilityHookup]
  # @return [Hookup]
  def self.from_utility_hookup(utility_hookup)
    new_from_slug(utility_hookup.utility_slug, utility_hookup: utility_hookup)
  end

  def self.new_from_slug(slug, attributes = {})
    REGISTRY.fetch(slug.to_sym, NullHookup).new(attributes)
  end

  class NullHookup < Hookup
  end
end
