require "rails_helper"

RSpec.describe Marketplace::SquareOrder do
  describe "send_to_seller_dashboard" do
    it "will return the correct success data" do
      # TODO
    end

    it "will noop when an error occurs" do
      # TODO
    end
  end

  describe "#prepare_square_create_order_payment_body" do
    it "returns the correct object shape and data" do
      # TODO
    end

    it "returns the correct object shape and data" do
      # TODO
    end
  end

  describe "#prepare_square_create_order_body" do
    it "returns the correct object shape and data for a logged-in shopper" do
      # TODO
    end

    it "returns the correct object shape and data for a guest shopper" do
      # TODO
    end
  end

  describe "#square_idemp_key" do
    it "returns a unique string made up of order id and 8 random numbers between 1-10" do
      # TODO
    end
  end
end
