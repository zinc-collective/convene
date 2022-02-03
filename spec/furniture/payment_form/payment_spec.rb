require 'rails_helper'

RSpec.describe PaymentForm::Payment, type: :model do
  subject { described_class.new(item_record: ItemRecord.new) }

  describe '#payer_name' do
    it { is_expected.to validate_presence_of(:payer_name) }
  end

  describe '#payer_email' do
    it { is_expected.to validate_presence_of(:payer_email) }
    it { is_expected.to allow_value('me@you.com').for(:payer_email) }
    it { is_expected.to_not allow_value('bogus.com').for(:payer_email) }
  end

  describe '#amount' do
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
  end

  describe '#memo' do
    it { is_expected.to validate_presence_of(:memo) }
  end

  describe '#plaid_account_id' do
    it { is_expected.to validate_presence_of(:plaid_account_id) }
  end

  describe '#plaid_item_id' do
    it { is_expected.to validate_presence_of(:plaid_item_id) }
  end
end
