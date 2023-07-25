class Marketplace
  class SplitJob < ApplicationJob
    attr_accessor :order
    delegate :vendors_share, :marketplace, to: :order
    delegate :stripe_api_key, :vendor_stripe_account, to: :marketplace

    sidekiq_options retry: 5
    sidekiq_retry_in { |count, exception, jobhash| 1.day }

    def perform(order:)
      self.order = order

      Stripe::Transfer.create({
        amount: vendors_share,
        currency: "usd",
        destination: vendor_stripe_account,
        transfer_group: order.id
      }, {api_key: stripe_api_key})
      order.events.create(description: "Payment Split")
    end
  end
end
