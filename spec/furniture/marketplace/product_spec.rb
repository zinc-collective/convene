require "rails_helper"

RSpec.describe Marketplace::Product, type: :model do
  it { is_expected.to belong_to(:marketplace) }

  describe "#name" do
    it { is_expected.to validate_presence_of(:name) }
  end
end