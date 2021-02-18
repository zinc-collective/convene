# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Space, type: :model do
  describe '#name' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe '#branded_domain' do
    it { is_expected.to validate_uniqueness_of(:branded_domain).allow_nil }
  end

  it { is_expected.to have_many(:rooms) }
  it { is_expected.to belong_to(:entrance).class_name('Room').optional(true).dependent(false) }

  describe "#hookups=" do
    it "idempotently adds space hookups as configured" do

    end
  end
end
