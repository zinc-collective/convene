# frozen_string_literal: true

module Hookups
  # Inherit from this to build out your own Hookups!
  class Hookup
    include ActiveModel::Model

    # @return [SpaceHookup]
    attr_accessor :space_hookup

    # @return [Space]
    delegate :space, to: :space_hookup

    # @return [Hookups::Configuration]
    def configuration
      @configuration ||= Configuration.new(data: space_hookup.configuration)
    end
  end
end
