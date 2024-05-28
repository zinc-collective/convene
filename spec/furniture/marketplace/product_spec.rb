require "rails_helper"

RSpec.describe Marketplace::Product, type: :model do
  it { is_expected.to belong_to(:marketplace).inverse_of(:products) }
  it { is_expected.to have_many(:cart_products).inverse_of(:product).dependent(:destroy) }
  it { is_expected.to have_many(:carts).through(:cart_products).inverse_of(:products) }
  it { is_expected.to have_many(:product_tax_rates).inverse_of(:product).dependent(:destroy) }
  it { is_expected.to have_many(:tax_rates).through(:product_tax_rates).inverse_of(:products) }

  describe ".with_group_tag" do
    subject(:with_group_tag) { described_class.with_group_tag }

    let!(:untagged_product) { create(:marketplace_product) }
    let!(:product_with_non_group_tag) do
      create(:marketplace_product).tap { |p| p.tags << create(:marketplace_tag) }
    end
    let!(:product_with_group_tag) do
      create(:marketplace_product).tap { |p| p.tags << create(:marketplace_tag, :group) }
    end

    it "returns only products with a group tag" do
      expect(with_group_tag).to include(product_with_group_tag)
      expect(with_group_tag).not_to include(untagged_product)
      expect(with_group_tag).not_to include(product_with_non_group_tag)
    end
  end

  describe ".without_group_tag" do
    subject(:without_group_tag) { described_class.without_group_tag }

    let!(:untagged_product) { create(:marketplace_product) }
    let!(:product_with_non_group_tag) do
      create(:marketplace_product).tap { |p| p.tags << create(:marketplace_tag) }
    end
    let!(:product_with_group_tag) do
      create(:marketplace_product).tap { |p| p.tags << create(:marketplace_tag, :group) }
    end

    it "returns only products without a group tag" do
      expect(without_group_tag).to include(untagged_product)
      expect(without_group_tag).to include(product_with_non_group_tag)
      expect(without_group_tag).not_to include(product_with_group_tag)
    end
  end

  describe "#name" do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "#price=" do
    it("sets the price_cents") do
      product = described_class.new
      product.price = 20
      expect(product.price_cents).to be(2000)
    end
  end

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
    subject(:product) { build(:marketplace_product) }

    it { is_expected.not_to be_destroyable }

    context "when a delivery area is persisted" do
      subject(:product) { create(:marketplace_product) }

      it { is_expected.not_to be_destroyable }

      context "when the delivery area is archived" do
        subject(:product) { create(:marketplace_product, :archived) }

        it { is_expected.to be_destroyable }

        context "when the delivery area has orders" do
          subject(:product) { create(:marketplace_product, :archived) }

          let(:order) { create(:marketplace_order) }

          before { order.products << product }

          it { is_expected.not_to be_destroyable }
        end
      end
    end
  end
end
