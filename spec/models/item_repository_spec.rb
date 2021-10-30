# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItemRepository do
  let(:item_repository) do
    ItemRepository.new(type: CheckDropbox::Check, item_records: item_records, space: space)
  end
  let(:type) { CheckDropbox::Check }
  let(:item_records) { location.item_records }
  let(:location) { FactoryBot.create(:furniture_placement) }
  let(:space) { location.space }
  describe '#new' do
    it 'instantiates an item record with the given attributes within the item records' do
      item = item_repository.new(status: 'green')

      expect(item.status).to eql(:green)
      expect(item).to be_a(CheckDropbox::Check)
      expect(location.item_records).to include(item.item_record)
    end
  end

  describe '#create' do
    it 'persist an item record with the given attributes within the item records' do
      item = item_repository.create(status: 'green')

      expect(item.status).to eql(:green)
      expect(item).to be_a(CheckDropbox::Check)
      expect(location.item_records).to include(item.item_record)
      expect(item).to be_persisted
    end
  end
end
