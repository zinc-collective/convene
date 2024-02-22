require "rails_helper"

RSpec.describe Marketplace::ProductsController, type: :request do
  let(:marketplace) { create(:marketplace) }
  let(:space) { marketplace.space }
  let(:room) { marketplace.room }
  let(:member) { create(:membership, space: space).member }

  describe "#create" do
    subject(:perform_request) do
      post polymorphic_path([space, room, marketplace, :products]),
        params: {product: product_attributes}
      response
    end

    let(:tax_rate) { create(:marketplace_tax_rate, marketplace: marketplace) }
    let(:product_attributes) { attributes_for(:marketplace_product, :with_photo, tax_rate_ids: [tax_rate.id]) }

    before do
      sign_in(space, member)
    end

    specify { expect { perform_request }.to change(marketplace.products, :count).by(1) }

    describe "the created product" do
      subject(:created_product) { marketplace.products.last }

      before { perform_request }

      specify { expect(created_product.name).to eql(product_attributes[:name]) }
      specify { expect(created_product.description.body).to eql(product_attributes[:description]) }
      specify { expect(created_product.price_cents).to eql(product_attributes[:price_cents]) }
      specify { expect(created_product.price_currency).to eql(Money.default_currency.to_s) }
      specify { expect(created_product.tax_rates).to include(tax_rate) }
      specify { expect(created_product.photo).to be_present }
    end

    describe "when product is invalid" do
      let(:product_attributes) { {description: "test"} }

      it { is_expected.to have_rendered(:new) }
    end
  end

  describe "#edit" do
    it "Shows the form to edit a Marketplace Product" do
      sign_in(space, member)
      product = create(:marketplace_product, marketplace: marketplace)

      get polymorphic_path(product.location(:edit))
      expect(response).to have_rendered(:edit)
    end
  end
end
