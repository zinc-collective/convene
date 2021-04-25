# frozen_string_literal: true

module Utilities
  # A {Utility} is how we connect the broader Internet to a Space.
  #
  # @see features/utilities.feature
  class Utility
    include ActiveModel::Model

    # @return [UtilityHookup]
    attr_accessor :utility_hookup

    # @return [Space]
    delegate :space, to: :utility_hookup

    # @return [Utilities::Configuration]
    def configuration
      @configuration ||= Configuration.new(data: utility_hookup&.configuration)
    end

    # Standard permissions for how Utilities can be managed.
    # Can be overridden on a per-Utility basis.
    class Policy
      def initialize(person, utility)
        self.person = person
        self.utility = utility
      end
    end
  end
end
