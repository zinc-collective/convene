require "rails_helper"

RSpec.describe Marketplace::CartProduct, type: :model do
  subject(:cart_product) { build(:marketplace_cart_product) }

  it { is_expected.to belong_to(:cart).inverse_of(:cart_products) }

  it { is_expected.to belong_to(:product).inverse_of(:cart_products) }
  it { is_expected.to validate_uniqueness_of(:product).scoped_to(:cart_id) }
end
