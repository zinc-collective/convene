require 'rails_helper'

RSpec.describe FurniturePlacement do
  it { is_expected.to belong_to(:room) }
  it { is_expected.to delegate_method(:space).to(:room) }

  describe '#furniture' do
    it 'returns the configured piece of furniture' do
      furniture_placement = FurniturePlacement
                            .new(furniture_kind: :breakout_tables_by_jitsi, settings: { names: %w[a b] })

      expect(furniture_placement.furniture).to be_a(BreakoutTablesByJitsi)
      expect(furniture_placement.furniture.placement).to eql(furniture_placement)
      expect(furniture_placement.furniture.tables.to_a[0].name).to eql('a')
      expect(furniture_placement.furniture.tables.to_a[1].name).to eql('b')
    end
  end

  describe '#slot' do
    let(:room) { create(:room) }
    let!(:placements) { create_list(:furniture_placement, 3, room: room) }

    it 'inserts new placement between existing slots' do
      placement1, placement2, placement3 = placements
      new_placement = create(:furniture_placement, room: room, slot_position: 1)
      expect(placement1.slot_rank).to eq(0)
      expect(new_placement.slot_rank).to eq(1)
      expect(placement2.slot_rank).to eq(2)
      expect(placement3.slot_rank).to eq(3)
    end

    it 'it gets placed last without an explicit position' do
      new_placement = create(:furniture_placement, room: room, slot_position: nil)
      expect(new_placement).to be_valid
      expect(new_placement.slot_position).to eq(:last)
    end
  end
end
