# frozen_string_literal: true

# {Utilities} allow external services to provide functionality to a {Space} and
# its {Furniture}.
#
# Every {Space} can have {UtilityHookup}s that securely store API keys and other
# configuration for the {Utility} to work with the {Space}.
#
# @see features/utilities.feature
# @see features/utilities/
module Utilities
  REGISTRY = {
    stripe: ::StripeUtility
  }.freeze

  # @param utility_hookup [UtilityHookup]
  # @return [Utility]
  def self.from_utility_hookup(utility_hookup)
    fetch(utility_hookup.utility_slug)
      .from_utility_hookup(utility_hookup)
  end

  def self.new_from_slug(slug, attributes = {})
    fetch(slug).new(attributes)
  end

  def self.fetch(slug)
    REGISTRY.fetch(slug&.to_sym, UtilityHookup)
  end
end
