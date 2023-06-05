# frozen_string_literal: true

require "rails_helper"

RSpec.describe Space do
  subject(:space) { described_class.new }

  it { is_expected.to have_many(:rooms).dependent(:destroy) }
  it { is_expected.to have_many(:furnitures).through(:rooms).inverse_of(:space) }
  it { is_expected.to have_many(:utilities).inverse_of(:space).dependent(:destroy) }

  it { is_expected.to have_many(:agreements).inverse_of(:space).dependent(:destroy) }

  it do
    expect(space).to belong_to(:entrance).class_name("Room")
      .optional(true).dependent(false)
  end

  it { is_expected.to have_many(:memberships).inverse_of(:space).dependent(:destroy) }
  it { is_expected.to have_many(:invitations).inverse_of(:space).dependent(:destroy) }

  describe "#name" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe "#branded_domain" do
    it { is_expected.to validate_uniqueness_of(:branded_domain).allow_nil }
  end

  describe "#enforce_ssl?" do
    subject(:enforce_ssl?) { space.enforce_ssl? }

    let(:space) { create(:space) }

    it "is false by default" do
      expect(enforce_ssl?).to be false
    end

    context "when set to true" do
      before { space.update(enforce_ssl: true) }

      it "is true" do
        expect(enforce_ssl?).to be true
      end
    end
  end
end
