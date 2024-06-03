require "rails_helper"

RSpec.describe Marketplace::Tag, type: :model do
  subject { build(:marketplace_tag) }

  it { is_expected.to validate_uniqueness_of(:label).case_insensitive.scoped_to(:marketplace_id) }

  describe ".menu_tag" do
    subject(:menu_tag) { described_class.menu_tag }

    let!(:tag) { create(:marketplace_tag, :menu) }
    let!(:not_menu_tag) { create(:marketplace_tag) }

    it "only returns tags that are groups" do
      expect(menu_tag).to include(tag)
      expect(menu_tag).not_to include(not_menu_tag)
    end
  end

  describe ".by_position" do
    subject(:by_position) { described_class.by_position }

    let(:marketplace) { create(:marketplace) }
    let!(:menu_tags) do
      # The positioning gem won't let us manually assign positions on creation
      create_list(:marketplace_tag, 3, :menu, marketplace: marketplace).tap do |tags|
        tags[0].update(position: :last)
        tags[2].update(position: :first)
      end
    end

    before do
      freeze_time  # Freeze time so that the `updated_at` values are the same
    end

    it "sorts tags by ascending position" do
      expect(by_position).to eq([menu_tags[2], menu_tags[1], menu_tags[0]])
    end
  end
end
