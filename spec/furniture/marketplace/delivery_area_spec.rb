require "rails_helper"

RSpec.describe Marketplace::DeliveryArea, type: :model do
  it { is_expected.to belong_to(:marketplace).inverse_of(:delivery_areas) }
  it { is_expected.to have_many(:orders).inverse_of(:delivery_area) }
  it { is_expected.to have_many(:carts).inverse_of(:delivery_area) }
  it { is_expected.to have_many(:deliveries).inverse_of(:delivery_area) }
end
