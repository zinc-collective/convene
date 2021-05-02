# frozen_string_literal: true

# An internal Microlibrary for feature flagging to help avoid
# sprinkling `ENV` calls throughout the codebase.
class Feature
  # @param [Symbol, #to_sym] feature The name of the feature we are checking
  # @return [TrueClass, FalseClass]
  def self.enabled?(feature)
    feature = feature.to_sym if feature.respond_to?(:to_sym)
    return true if feature == :demo && ENV['DEMO_ENABLED']
    return true if feature == :system_test && ENV['SYSTEM_TEST']
    return true if feature == :configure_room && ENV['CONFIGURE_ROOM']

    false
  end
end
