# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItemRepository do
  let(:item_repository) { ItemRepository.new(type: Furniture::CheckDropbox::Check, item_records: item_records) }
  let(:type) { Furniture::CheckDropbox::Check }
  let(:item_records) { location.item_records }
  let(:location) { FactoryBot.create(:furniture_placement) }
  describe '#new' do
    it 'instantiates an item record with the given attributes within the item records' do
      item = item_repository.new(status: 'green')

      expect(item.status).to eql(:green)
      expect(item).to be_a(Furniture::CheckDropbox::Check)
      expect(location.item_records).to include(item.item_record)
    end
  end

  describe '#create' do
    it 'persist an item record with the given attributes within the item records' do
      item = item_repository.create(status: 'green')

      expect(item.status).to eql(:green)
      expect(item).to be_a(Furniture::CheckDropbox::Check)
      expect(location.item_records).to include(item.item_record)
      expect(item).to be_persisted
    end
  end
end
