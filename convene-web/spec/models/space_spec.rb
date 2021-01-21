require "rails_helper"

RSpec.describe Space, type: :model do
  describe "#name" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe "#branded_domain" do
    it { is_expected.to validate_uniqueness_of(:branded_domain).allow_nil }
  end
end
