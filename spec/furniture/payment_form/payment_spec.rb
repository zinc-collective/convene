require "rails_helper"

RSpec.describe PaymentForm::Payment, type: :model do
  subject { described_class.new }

  describe "#payer_name" do
    it { is_expected.to validate_presence_of(:payer_name) }
  end

  describe "#payer_email" do
    it { is_expected.to validate_presence_of(:payer_email) }
    it { is_expected.to allow_value("me@you.com").for(:payer_email) }
    it { is_expected.not_to allow_value("bogus.com").for(:payer_email) }
  end

  describe "#amount" do
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
  end

  describe "#memo" do
    it { is_expected.to validate_presence_of(:memo) }
  end

  describe "#plaid_account_id" do
    it { is_expected.to validate_presence_of(:plaid_account_id) }
  end

  describe "#plaid_item_id" do
    it { is_expected.to validate_presence_of(:plaid_item_id) }
  end

  describe "stored_attributes for #data" do
    described_class.stored_attributes[:data].each do |attribute|
      next if attribute == :status # special case, tested separaately

      it "provides an accessor for #{attribute}" do
        expect(subject.send("#{attribute}=", "some value")).to eq("some value")
        expect(subject.send("#{attribute}")).to eq("some value")
        expect(subject.data[attribute.to_s]).to eq("some value")
      end
    end
  end

  describe "#status" do
    it "returns a symbol" do
      subject.status = "accepted"
      expect(subject.status).to eq(:accepted)
    end
  end
end
