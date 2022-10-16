require "rails_helper"

RSpec.describe Marketplace::Order, type: :model do
  it { should have_many(:ordered_products) }

  it { should have_many(:products).through(:ordered_products) }

  it { should belong_to(:marketplace).class_name('Marketplace::Marketplace')}
end