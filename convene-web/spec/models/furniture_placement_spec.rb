require 'rails_helper'

RSpec.describe FurniturePlacement do
  it {
    is_expected.to validate_uniqueness_of(:name)
      .scoped_to(:room_id)
  }
  it { is_expected.to belong_to(:room) }

  it { is_expected.to validate_presence_of(:slot) }
  it {
    is_expected.to validate_uniqueness_of(:slot)
      .scoped_to(:room_id)
  }

  it { is_expected.to delegate_method(:space).to(:room) }

  describe '#furniture' do
    it 'returns the configured piece of furniture' do
      furniture_placement = FurniturePlacement
                            .new(name: :tables, settings: { names: %w[a b] })

      expect(furniture_placement.furniture).to be_a(Furniture::BreakoutTables)
      expect(furniture_placement.furniture.placement).to eql(furniture_placement)
      expect(furniture_placement.furniture.tables.to_a[0].name).to eql('a')
      expect(furniture_placement.furniture.tables.to_a[1].name).to eql('b')
    end
  end
end
