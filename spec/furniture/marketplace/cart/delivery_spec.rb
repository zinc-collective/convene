require "rails_helper"

RSpec.describe Marketplace::Cart::Delivery, type: :model do
  it { is_expected.to belong_to(:delivery_area) }
  it { is_expected.to validate_presence_of(:delivery_area_id) }

  describe "#contact_email" do
    it { is_expected.to validate_presence_of(:contact_email) }
  end

  describe "#contact_phone_number" do
    it { is_expected.to validate_presence_of(:contact_phone_number) }
  end

  describe "#delivery_address" do
    it { is_expected.to validate_presence_of(:delivery_address) }
  end

  describe "#delivery_window" do
    it { is_expected.to validate_presence_of(:delivery_window) }
  end
end
