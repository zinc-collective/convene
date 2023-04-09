require "rails_helper"

RSpec.describe Marketplace::Cart::DeliveryPolicy, type: :policy do
  subject(:delivery_policy) { described_class.new(person, delivery) }

  let(:person) { nil }
  let(:delivery) { nil }

  describe "#permitted_attributes" do
    subject(:permitted_attributes) { delivery_policy.permitted_attributes(nil) }

    it { is_expected.to include(:delivery_area_id) }
    it { is_expected.to include(:contact_phone_number) }
    it { is_expected.to include(:contact_email) }
    it { is_expected.to include(:delivery_address) }
    it { is_expected.to include(:delivery_window) }
  end
end
