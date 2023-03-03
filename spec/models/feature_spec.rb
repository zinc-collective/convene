require "rails_helper"
RSpec.describe Feature do
  subject(:Feature) { Feature }
  describe ".enabled?(feature_name)" do
    before { stub_const("ENV", "FEATURE_FOO" => "true", "FEATURE_BAR" => "yes") }

    it { is_expected.to be_enabled(:foo) }
    it { is_expected.not_to be_enabled(:bar) }
    it { is_expected.not_to be_enabled(:baz) }
  end
end
