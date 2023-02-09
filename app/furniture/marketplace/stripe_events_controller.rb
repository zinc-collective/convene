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

        Stripe::Transfer.create({
          amount: order.price_total.cents,
          currency: "usd",
          destination: marketplace.stripe_account,
          transfer_group: order.id
        }, {api_key: marketplace.stripe_api_key})
      else
        raise UnexpectedStripeEventTypeError, event.type
      end
    end
  end
end
