require 'rails_helper'

RSpec.describe Marketplace::Product, type: :model do
  it { is_expected.to belong_to(:marketplace) }

  describe '#name' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe '#price=' do
    it('sets the price_cents') do
      product = Marketplace::Product.new
      product.price = 20
      expect(product.price_cents).to eql(2000)
    end
  end
end

# TODO: fill in request spec
RSpec.describe "/spaces/:space_slug/rooms/:room_slug/marketplaces/:marketplace_slug/products", type: :request do
  
  describe "POST /spaces/:space_slug/rooms/:room_slug/marketplaces/:marketplace_slug/products" do
    
    it "creates a product in a Marketplace" do
    end

    it "updates a product in a Marketplace" do
    end
  
  end
end