# frozen_string_literal: true

require "rails_helper"

RSpec.describe Space do
  it { is_expected.to have_many(:rooms) }
  it { is_expected.to have_many(:furnitures).through(:rooms).inverse_of(:space) }

  it { is_expected.to have_many(:agreements).inverse_of(:space).dependent(:destroy) }

  it do
    expect(subject).to belong_to(:entrance).class_name("Room")
      .optional(true).dependent(false)
  end

  it { is_expected.to have_many(:invitations).inverse_of(:space) }

  describe "#name" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe "#branded_domain" do
    it { is_expected.to validate_uniqueness_of(:branded_domain).allow_nil }
  end
end
