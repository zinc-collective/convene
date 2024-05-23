require "rails_helper"

RSpec.describe Marketplace::Tag, type: :model do
  subject { build(:marketplace_tag) }

  it { is_expected.to validate_uniqueness_of(:label).case_insensitive.scoped_to(:marketplace_id) }

  describe ".group_tag" do
    subject(:group_tag) { described_class.group_tag }

    let!(:tag) { create(:marketplace_tag, :group) }
    let!(:not_group_tag) { create(:marketplace_tag) }

    it "only returns tags that are groups" do
      expect(group_tag).to include(tag)
      expect(group_tag).not_to include(not_group_tag)
    end
  end

  describe ".by_position" do
    subject(:by_position) { described_class.by_position }

    let!(:second_tag) { create(:marketplace_tag, position: 2) }
    let!(:first_tag) { create(:marketplace_tag, position: 1) }

    before do
      freeze_time  # Freeze time so that the `updated_at` values are the same
    end

    it "sorts tags by ascending position" do
      expect(by_position).to eq([first_tag, second_tag])
    end
  end
end
