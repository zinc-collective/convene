require "rails_helper"

RSpec.describe Marketplace::ProductsController, type: :request do
  let(:marketplace) { create(:marketplace) }
  let(:space) { marketplace.space }
  let(:room) { marketplace.room }
  let(:member) { create(:membership, space: space).member }

  describe "#create" do
    it "Creates a Product in the Marketplace" do
      attributes = attributes_for(:marketplace_product)

      sign_in(space, member)

      expect do
        post polymorphic_path([space, room, marketplace, :products]),
          params: {product: attributes}
      end.to change(marketplace.products, :count).by(1)

      created_product = marketplace.products.last
      expect(created_product.name).to eql(attributes[:name])
      expect(created_product.description).to eql(attributes[:description])
      expect(created_product.price_cents).to eql(attributes[:price_cents])
      expect(created_product.price_currency).to eql(Money.default_currency.to_s)
    end
  end

  describe "#edit" do
    it "Shows the form to edit a Marketplace Product" do
      product = create(:marketplace_product, marketplace: marketplace)

      get polymorphic_path([:edit, space, room, marketplace, product])
      expect(response).to render_template(:edit)
    end
  end
end
