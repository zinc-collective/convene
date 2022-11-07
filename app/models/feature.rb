# frozen_string_literal: true

# An internal Microlibrary for feature flagging to help avoid
# sprinkling `ENV` calls throughout the codebase.
class Feature
  # @param [String, #to_s] feature Name of the feature we're flagging
  # @return [TrueClass, FalseClass]
  def self.enabled?(feature)
    feature = feature.to_s if feature.respond_to?(:to_s)

    ENV.fetch("FEATURE_#{feature.upcase}", "false") == "true"
  end
end
