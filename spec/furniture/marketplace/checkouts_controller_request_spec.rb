require "rails_helper"

RSpec.describe Marketplace::Checkout, type: :request do
  let(:marketplace) { create(:marketplace) }
  let(:space) { marketplace.space }
  let(:room) { marketplace.room }

  describe "#create" do
    it "Create Checkout from a Cart" do
      # TODO: insert test
    end
  end
end
