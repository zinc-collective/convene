require "rails_helper"

RSpec.describe Furniture do
  it { is_expected.to belong_to(:room) }
  it { is_expected.to delegate_method(:space).to(:room) }

  describe "#furniture" do
    it "returns the configured piece of furniture" do
      furniture = build(:furniture, settings: {content: "# A Block"})

      expect(furniture.furniture).to be_a(MarkdownTextBlock)
      expect(furniture.furniture.content).to eql("# A Block")
    end
  end

  describe "#slot" do
    let(:room) { create(:room) }
    let(:placements) { create_list(:furniture, 3, room: room) }
    let(:placement1) { placements[0] }
    let(:placement2) { placements[1] }
    let(:placement3) { placements[2] }

    before {
      placement1
      placement2
      placement3
    }

    it "inserts new placement between existing slots" do
      new_placement = create(:furniture, room: room, slot_position: 1)
      expect(placement1.slot_rank).to eq(0)
      expect(new_placement.slot_rank).to eq(1)
      expect(placement2.slot_rank).to eq(2)
      expect(placement3.slot_rank).to eq(3)
    end

    it "gets placed last without an explicit position" do
      new_placement = create(:furniture, room: room, slot_position: nil)
      expect(new_placement).to be_valid
      expect(new_placement.slot_position).to eq(:last)
    end
  end
end
