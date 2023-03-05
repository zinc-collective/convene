require "rails_helper"

RSpec.describe Marketplace::Product, type: :model do
  it { is_expected.to belong_to(:marketplace).inverse_of(:products) }
  it { is_expected.to have_many(:cart_products).inverse_of(:product).dependent(:destroy) }
  it { is_expected.to have_many(:carts).through(:cart_products).inverse_of(:products) }

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
end
