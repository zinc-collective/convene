require "rails_helper"

RSpec.describe FurniturePlacement do
  it { is_expected.to belong_to(:room) }
  it { is_expected.to delegate_method(:space).to(:room) }
  it { is_expected.to have_many(:items).with_foreign_key(:location_id).inverse_of(:location) }

  describe "#furniture" do
    it "returns the configured piece of furniture" do
      furniture_placement = build(:furniture_placement, settings: { content: "# A Block"})

      expect(furniture_placement.furniture).to be_a(MarkdownTextBlock)
      expect(furniture_placement.furniture.placement).to eql(furniture_placement)
      expect(furniture_placement.furniture.content).to eql("# A Block")
    end
  end

  describe "#slot" do
    let(:room) { create(:room) }
    let!(:placements) { create_list(:furniture_placement, 3, room: room) }

    it "inserts new placement between existing slots" do
      placement1, placement2, placement3 = placements
      new_placement = create(:furniture_placement, room: room, slot_position: 1)
      expect(placement1.slot_rank).to eq(0)
      expect(new_placement.slot_rank).to eq(1)
      expect(placement2.slot_rank).to eq(2)
      expect(placement3.slot_rank).to eq(3)
    end

    it "gets placed last without an explicit position" do
      new_placement = create(:furniture_placement, room: room, slot_position: nil)
      expect(new_placement).to be_valid
      expect(new_placement.slot_position).to eq(:last)
    end
  end
end
