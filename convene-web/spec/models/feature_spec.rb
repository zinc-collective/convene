require 'rails_helper'
RSpec.describe Feature do
  describe '.enabled?(feature_name)' do
    it "is only true when the feature name is set to 'true' in the ENV" do
      stub_const('ENV', { 'FEATURE_FOO' => 'true', 'FEATURE_BAR' => 'yes' })

      expect(Feature.enabled?(:foo)).to be_truthy
      expect(Feature.enabled?(:bar)).not_to be_truthy
      expect(Feature.enabled?(:baz)).not_to be_truthy
    end

    it 'supports the legacy feature flag environment names (for now)' do
      stub_const('ENV',
                 { 'DEMO_ENABLED' => 'true',
                   'SYSTEM_TEST' => 'true',
                   'CONFIGURE_ROOM' => 'true',

                   'IDENTIFICATION' => 'true' })

      expect(Feature.enabled?(:demo)).to be_truthy
      expect(Feature.enabled?(:system_test)).to be_truthy
      expect(Feature.enabled?(:identification)).to be_truthy
      expect(Feature.enabled?(:configure_room)).to be_truthy
    end
  end
end
