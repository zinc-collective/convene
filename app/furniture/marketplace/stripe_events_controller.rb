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

        shipping_address = event.data.object.shipping.address
        delivery_address =
          [event.data.object.shipping.name,
           shipping_address.line1,
           shipping_address.line2,
           "#{shipping_address.city}, #{shipping_address.state} #{shipping_address.postal_code}",
        ].compact.join("\n")
        order.update(delivery_address: delivery_address,
          status: :paid,
          contact_email: event.data.object.customer_details.email)

        OrderReceivedMailer.notification(order).deliver_later

        Stripe::Transfer.create({
        amount: order.product_total.cents,
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
