require "rails_helper"

RSpec.describe Marketplace::Bazaar, type: :model do
  it { is_expected.to have_many(:marketplaces).through(:rooms).inverse_of(:bazaar) }
  it { is_expected.to have_many(:tax_rates).inverse_of(:bazaar).dependent(:destroy) }
end
