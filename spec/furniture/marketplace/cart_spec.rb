require "rails_helper"

RSpec.describe Marketplace::Cart, type: :model do
  it { is_expected.to have_many(:cart_products) }

  it { is_expected.to have_many(:products).through(:cart_products) }

  it { is_expected.to belong_to(:marketplace).class_name("Marketplace::Marketplace") }
end
