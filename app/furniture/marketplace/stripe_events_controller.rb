class Marketplace
  class StripeEventsController < Controller
    skip_before_action :verify_authenticity_token

    def create
      skip_authorization
      payload = request.body.read
      signature = request.env["HTTP_STRIPE_SIGNATURE"]

      event = Stripe::Webhook.construct_event(payload, signature, marketplace.stripe_webhook_endpoint_secret)

      case event.type

      when "checkout.session.completed"
        payment_intent = Stripe::PaymentIntent.retrieve(event.data.object.payment_intent, {api_key: marketplace.stripe_api_key})

        order = Order.find(payment_intent.transfer_group)

        return if order.paid?

        latest_charge = Stripe::Charge.retrieve(payment_intent.latest_charge, api_key: marketplace.stripe_api_key)
        balance_transaction = Stripe::BalanceTransaction.retrieve(latest_charge.balance_transaction, api_key: marketplace.stripe_api_key)

        order.update(status: :paid, placed_at: DateTime.now)

        Order::ReceivedMailer.notification(order).deliver_later
        Order::PlacedMailer.notification(order).deliver_later

        Stripe::Transfer.create({
          # Leave the Stripe Fees in the `Distributor`'s account
          amount: order.product_total.cents - balance_transaction.fee,
          currency: "usd",
          destination: marketplace.vendor_stripe_account,
          transfer_group: order.id
        }, {api_key: marketplace.stripe_api_key})
      else
        raise UnexpectedStripeEventTypeError, event.type
      end
    end
  end
end
