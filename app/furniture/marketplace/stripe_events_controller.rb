class Marketplace
  class StripeEventsController < Controller
    skip_before_action :verify_authenticity_token

    # @todo add signing check using the stripe webhook signing secret
    # @see https://stripe.com/docs/webhooks/quickstart
    def create
      skip_authorization
      payload = request.body.read
      signature = request.env["HTTP_STRIPE_SIGNATURE"]
      event = Stripe::Webhook.construct_event(params, signature, marketplace.stripe_webhook_endpoint_secret)

      case event.type

      when "checkout.session.completed"
        payment_intent = Stripe::PaymentIntent.retrieve(event.data.dig("object", "payment_intent"), {api_key: marketplace.stripe_api_key})
        order = Order.find(payment_intent.transfer_group)

        transfer = Stripe::Transfer.create({
          amount: order.price_total.cents,
          currency: "usd",
          destination: marketplace.stripe_account,
          transfer_group: order.id
        }, {api_key: marketplace.stripe_api_key})
      end
    end
  end
end
