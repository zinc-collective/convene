require "rails_helper"

RSpec.describe Marketplace::Marketplace, type: :model do
  it { is_expected.to have_many(:products).inverse_of(:marketplace) }
  it { is_expected.to have_many(:carts).inverse_of(:marketplace) }
end
