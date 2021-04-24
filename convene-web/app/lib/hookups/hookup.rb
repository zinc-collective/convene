# frozen_string_literal: true

module Hookups
  # Inherit from this to build out your own Hookups!
  class Hookup
    include ActiveModel::Model

    # @return [UtilityHookup]
    attr_accessor :utility_hookup

    # @return [Space]
    delegate :space, to: :utility_hookup

    # @return [Hookups::Configuration]
    def configuration
      @configuration ||= Configuration.new(data: utility_hookup&.configuration)
    end
  end
end
