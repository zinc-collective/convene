require "rails_helper"

RSpec.describe Marketplace::DeliveryArea, type: :model do
  it { is_expected.to belong_to(:marketplace).inverse_of(:delivery_areas) }
  it { is_expected.to have_many(:orders).inverse_of(:delivery_area) }
  it { is_expected.to have_many(:carts).inverse_of(:delivery_area) }
  it { is_expected.to have_many(:deliveries).inverse_of(:delivery_area) }

  describe "#archivable?" do
    subject(:delivery_area) { build(:marketplace_delivery_area) }

    it { is_expected.not_to be_archivable }

    context "when the delivery area is persisted" do
      subject(:delivery_area) { create(:marketplace_delivery_area) }

      it { is_expected.to be_archivable }

      context "when the delivery area is archived already" do
        subject(:delivery_area) { create(:marketplace_delivery_area, :archived) }

        it { is_expected.not_to be_archivable }
      end
    end
  end

  describe "#destroyable?" do
    subject(:delivery_area) { build(:marketplace_delivery_area) }

    it { is_expected.not_to be_destroyable }

    context "when a delivery area is persisted" do
      subject(:delivery_area) { create(:marketplace_delivery_area) }

      it { is_expected.not_to be_destroyable }

      context "when the delivery area is archived" do
        subject(:delivery_area) { create(:marketplace_delivery_area, :archived) }

        it { is_expected.to be_destroyable }

        context "when the delivery area has orders" do
          subject(:delivery_area) { create(:marketplace_delivery_area, :archived) }

          before { create(:marketplace_order, delivery_area:) }

          it { is_expected.not_to be_destroyable }
        end
      end
    end
  end
end
