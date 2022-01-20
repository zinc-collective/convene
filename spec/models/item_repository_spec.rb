# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItemRepository do
  let(:item_repository) do
    ItemRepository.new(item_records: item_records, space: space)
  end
  let(:item_records) { location.item_records }
  let(:location) { FactoryBot.create(:furniture_placement) }
  let(:space) { location.space }
  describe '#new' do
    it 'instantiates an item record with the given attributes within the item records' do
      item = item_repository.new(data: { some: 'stuff' })

      expect(item.data).to eq({ 'some' => 'stuff' })
      expect(item).to be_a(Item)
      expect(location.item_records).to include(item.item_record)
    end
  end

  describe '#create' do
    it 'persist an item record with the given attributes within the item records' do
      item = item_repository.create(data: { some: 'stuff' })

      expect(item.data).to include({ 'some' => 'stuff' })
      expect(item).to be_a(Item)
      expect(location.item_records).to include(item.item_record)
      expect(item).to be_persisted
    end
  end
end
