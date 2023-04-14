require "rails_helper"

RSpec.describe Space::Agreement do
  subject(:agreement) { build(:space_agreement) }

  it { is_expected.to belong_to(:space).inverse_of(:agreements) }
  it { is_expected.to validate_presence_of :body }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:space_id) }
  it { is_expected.to validate_uniqueness_of(:slug).scoped_to(:space_id) }
end
