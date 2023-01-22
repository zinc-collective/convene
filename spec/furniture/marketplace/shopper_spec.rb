require "rails_helper"

RSpec.describe Marketplace::Shopper, type: :model do
  it { is_expected.to belong_to(:person).optional }

  it { is_expected.to have_many(:carts).inverse_of(:shopper) }
  it { is_expected.to have_many(:orders).inverse_of(:shopper) }
end
