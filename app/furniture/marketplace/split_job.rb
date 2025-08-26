class Marketplace
  class SplitJob < ApplicationJob
    attr_accessor :order
    delegate :vendors_share, :marketplace, to: :order
    delegate :stripe_api_key, :vendor_stripe_account, to: :marketplace

    sidekiq_options retry: 5
    sidekiq_retry_in { |count, exception, jobhash| 1.day }

    def perform(order:)
      self.order = order
      order.events.create(description: "Payment Split Attempted")
      if order.stripe_transfer_id.present?
        order.events.create(description: "Payment Split Detected Existing Transfer")
        return
      end

      balance = Stripe::Balance.retrieve(api_key: stripe_api_key)
      total_available_balance =
        balance.available.sum { |balance| balance.amount }
      total_pending_balance =
        balance.pending.sum { |balance| balance.amount }

      if total_available_balance >= vendors_share.cents
        initiate_transfer
      else
        order.events.create(description: "Available balance of #{total_available_balance} insufficient to cover vendors share of #{order.vendors_share.cents}")
        if total_available_balance + total_pending_balance >= vendors_share.cents
          reschedule_split
        else
          order.events.create(description:
        "Pending balance (#{total_pending_balance}) and Available balance (#{total_available_balance}) does not covers vendors share #{order.vendors_share.cents}. Add funds to your Stripe Account so your Vendors get paid!")
          raise InsufficientBalanceError, "Available Balance: #{total_available_balance}, Pending Balance: #{total_pending_balance}, Vendors Share: #{order.vendors_share.cents}"
        end
      end
    end

    private def initiate_transfer
      transfer = Stripe::Transfer.create({
        amount: vendors_share.cents,
        currency: "usd",
        destination: vendor_stripe_account,
        transfer_group: order.id
      }, {api_key: stripe_api_key})

      order.update(stripe_transfer_id: transfer.id)
      order.events.create(description: "Payment Split Completed")
    end

    private def reschedule_split
      order.events.create(description:
        "Summing Pending and Available balances covers vendors share. Deferring split until #{24.hours.from_now.end_of_day}")
      SplitJob.set(wait_until: 24.hours.from_now.end_of_day).perform_later(order: order)
    end

    class InsufficientBalanceError < StandardError; end
  end
end
