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
        order = Order.unscoped.find_by(id: payment_intent.transfer_group, marketplace:)

        return if order.nil? || order.paid?

        latest_charge = Stripe::Charge.retrieve(payment_intent.latest_charge, api_key: marketplace.stripe_api_key)
        balance_transaction = Stripe::BalanceTransaction.retrieve(latest_charge.balance_transaction, api_key: marketplace.stripe_api_key)

        order.update!(status: :paid, placed_at: DateTime.now, payment_processor_fee_cents: balance_transaction.fee)
        order.events.create(description: "Payment Received")

        marketplace.square_connection&.send_order(order, latest_charge.id)

        Order::ReceivedMailer.notification(order).deliver_later
        order.events.create(description: "Notifications to Vendor and Distributor Sent")
        Order::PlacedMailer.notification(order).deliver_later
        order.events.create(description: "Notification to Buyer Sent")

        SplitJob.perform_later(order: order)
      else
        raise UnexpectedStripeEventTypeError, event.type
      end
    end
  end
end
