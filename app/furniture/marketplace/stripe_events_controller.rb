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
        order = marketplace.orders.find_by(id: payment_intent.transfer_group)

        return if order.nil? || order.paid?

        latest_charge = Stripe::Charge.retrieve(payment_intent.latest_charge, api_key: marketplace.stripe_api_key)
        balance_transaction = Stripe::BalanceTransaction.retrieve(latest_charge.balance_transaction, api_key: marketplace.stripe_api_key)

        order.latest_stripe_charge_id = latest_charge.id
        order.update!(status: :paid, placed_at: DateTime.now, payment_processor_fee_cents: balance_transaction.fee)
      else
        raise UnexpectedStripeEventTypeError, event.type
      end
    end
  end
end
