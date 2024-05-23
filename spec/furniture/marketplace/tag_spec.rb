require "rails_helper"

RSpec.describe Marketplace::Tag, type: :model do
  subject { build(:marketplace_tag) }

  it { is_expected.to validate_uniqueness_of(:label).case_insensitive.scoped_to(:marketplace_id) }
end
