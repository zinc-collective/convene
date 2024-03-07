require "rails_helper"

RSpec.describe Marketplace::Tag, type: :model do
  it { is_expected.to validate_uniqueness_of(:label).case_insensitive.scoped_to(:bazaar_id) }
end
