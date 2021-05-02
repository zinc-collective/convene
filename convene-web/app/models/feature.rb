# frozen_string_literal: true

# An internal Microlibrary for feature flagging to help avoid
# sprinkling `ENV` calls throughout the codebase.
class Feature
  # @param [String, #to_s] feature Name of the feature we're flagging
  # @return [TrueClass, FalseClass]
  def self.enabled?(feature)
    feature = feature.to_s if feature.respond_to?(:to_s)

    # @todo remove these after 6/1/2021
    return true if feature == 'demo' && ENV['DEMO_ENABLED']
    return true if feature == 'system_test' && ENV['SYSTEM_TEST']
    return true if feature == 'configure_room' && ENV['CONFIGURE_ROOM']
    return true if feature == 'identification' && ENV['IDENTIFICATION']

    ENV.fetch("FEATURE_#{feature.upcase}", 'false') == 'true'
  end
end
