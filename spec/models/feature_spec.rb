require "rails_helper"
RSpec.describe Feature do
  describe ".enabled?(feature_name)" do
    it "is only true when the feature name is set to 'true' in the ENV" do
      stub_const("ENV", {"FEATURE_FOO" => "true", "FEATURE_BAR" => "yes"})

      expect(Feature.enabled?(:foo)).to be_truthy
      expect(Feature.enabled?(:bar)).not_to be_truthy
      expect(Feature.enabled?(:baz)).not_to be_truthy
    end
  end
end
