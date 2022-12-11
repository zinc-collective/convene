require "rails_helper"

RSpec.describe Marketplace::Checkout, type: :model do
  it { is_expected.to belong_to(:cart).inverse_of(:checkout) }
  it { is_expected.to belong_to(:shopper).inverse_of(:checkouts) }
end
