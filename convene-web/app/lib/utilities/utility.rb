# frozen_string_literal: true

module Utilities
  # A {Utility} is how we connect the broader Internet to a Space.
  #
  # @see features/utilities.feature
  class Utility
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::AttributeAssignment
    # @return [UtilityHookup]
    attr_accessor :utility_hookup

    # @return [Space]
    delegate :space, :configuration, to: :utility_hookup

    def form_template
      "#{self.class.name.demodulize.underscore}/form"
    end

    # Standard permissions for how Utilities can be managed.
    # Can be overridden on a per-Utility basis.
    class Policy
      attr_accessor :person, :utility
      def initialize(person, utility)
        self.person = person
        self.utility = utility
      end
    end
  end
end
