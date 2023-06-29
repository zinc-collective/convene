# frozen_string_literal: true

require "rails_helper"

RSpec.describe Person do
  it { is_expected.to have_many(:invitations).inverse_of(:invitor).with_foreign_key(:invitor_id) }
  it { is_expected.to have_many(:authentication_methods).inverse_of(:person).dependent(:destroy) }
  it { is_expected.to have_many(:memberships).inverse_of(:member).dependent(:destroy) }
  it { is_expected.to have_many(:active_memberships).inverse_of(:member).dependent(:destroy) }

  describe "#display_name" do
    it "is blank when `name` and `email` are blank" do
      expect(described_class.new(name: "", email: nil).display_name).to be_blank
    end

    it "is the `name` when `name` is present and `email` is present" do
      expect(
        described_class.new(name: "Naomi", email: "naomi@example.com").display_name
      ).to eq("Naomi")
    end

    it "is the `email` when `name` is blank and `email` is present" do
      expect(
        described_class.new(name: "", email: "naomi@example.com").display_name
      ).to eq("naomi@example.com")
    end

    it "is the `name` when `name` is present and `email` is blank" do
      expect(
        described_class.new(name: "Naomi", email: nil).display_name
      ).to eq("Naomi")
    end
  end

  describe "#email" do
    it "automatically removes extra whitespace" do
      person = create(:person, email: " virgo@oakland.org ")
      expect(person.email).to eq("virgo@oakland.org")
    end
  end

  describe "#member_of?" do
    subject(:person) { membership.member }

    let(:space) { create(:space) }

    context "when a member" do
      let(:membership) { create(:membership, status: :active, space: space) }

      it { is_expected.to be_member_of(space) }
    end

    context "when not a member" do
      subject(:person) { create(:person) }

      it { is_expected.not_to be_member_of(space) }
    end

    context "when a revoked member" do
      let(:membership) { create(:membership, status: :revoked, space: space) }

      it { is_expected.not_to be_member_of(space) }
    end
  end
end
