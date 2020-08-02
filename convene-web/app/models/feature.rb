# An internal Microlibrary for feature flagging to help avoid
# sprinkling `ENV` calls throughout the codebase.
class Feature
  # @param [Symbol, #to_sym] feature The name of the feature we are checking
  # @return [TrueClass, FalseClass]
  def self.enabled?(feature)
    feature = feature.to_sym if feature.respond_to?(:to_sym)
    return true if feature == :demo && ENV['DEMO_ENABLED']
  end
end