require 'rails_helper'

RSpec.describe Marketplace::OrderedProduct, type: :model do
  subject(:ordered_product) { build(:marketplace_ordered_product) }
  it { should belong_to(:order).inverse_of(:ordered_products) }

  it { should belong_to(:product).inverse_of(:ordered_products) }
  it { should validate_uniqueness_of(:product).scoped_to(:order_id) }
end
