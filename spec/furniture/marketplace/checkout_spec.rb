require "rails_helper"

RSpec.describe Marketplace::Checkout, type: :model do
  subject(:checkout) { described_class.new(cart: create(:marketplace_cart)) }
end
