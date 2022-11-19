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

    it('edits the price_cents') do
      product = Marketplace::Product.new
      product.price = 10
      # TODO: FIX THIS TEST: edit the price via request response flow
      product.price = 30
      expect(product.price_cents).to eql(3000)
    end
  end

end
