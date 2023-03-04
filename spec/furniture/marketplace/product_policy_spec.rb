require "rails_helper"

RSpec.describe Marketplace::ProductPolicy do
  describe "#permitted_attributes" do
    subject(:permitted_attributes) { Marketplace::ProductPolicy.new(nil, nil).permitted_attributes }

    it { is_expected.to include :price }
  end
end
