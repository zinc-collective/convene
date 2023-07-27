require "rails_helper"
RSpec.describe Marketplace::Event, type: :model do
  it { is_expected.to belong_to(:regarding).inverse_of(:events) }
end
