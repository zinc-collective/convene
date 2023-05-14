require "rails_helper"

RSpec.describe Marketplace::TaxRate, type: :model do
  it { is_expected.to validate_presence_of(:tax_rate) }
  it { is_expected.to validate_numericality_of(:tax_rate).is_less_than_or_equal_to(100).is_greater_than(0) }
  it { is_expected.to validate_presence_of(:label) }

  it { is_expected.to have_many(:product_tax_rates).inverse_of(:tax_rate) }
  it { is_expected.to have_many(:products).through(:product_tax_rates).inverse_of(:tax_rates) }
  it { is_expected.to belong_to(:bazaar).inverse_of(:tax_rates) }
  it { is_expected.to belong_to(:marketplace).inverse_of(:tax_rates) }
end
