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

        order.update!(status: :paid, placed_at: DateTime.now, payment_processor_fee_cents: balance_transaction.fee)
        order.events.create(description: "Payment Received")

        square_client = Square::Client.new(
          access_token: marketplace.square_access_token,
          environment: "sandbox"
        )

        order_body = build_square_create_order_body(order)
        square_client.orders.create_order(order_body)
        payment_body = build_square_create_order_payment_body(order, marketplace, balance_transaction)

        # NOTE: Square requires that orders are paid in order to show up in the Seller Dashboard
        square_client.payments.create_payment(payment_body)

        order_to_square_order
        Order::ReceivedMailer.notification(order).deliver_later
        order.events.create(description: "Notifications to Vendor and Distributor Sent")
        Order::PlacedMailer.notification(order).deliver_later
        order.events.create(description: "Notification to Buyer Sent")

        Stripe::Transfer.create({
          # Leave the Stripe Fees in the `Distributor`'s account
          amount: order.product_total.cents - balance_transaction.fee,
          currency: "usd",
          destination: marketplace.vendor_stripe_account,
          transfer_group: order.id
        }, {api_key: marketplace.stripe_api_key})
        order.events.create(description: "Payment Split")
      else
        raise UnexpectedStripeEventTypeError, event.type
      end
    end

    def build_square_create_order_body(order, marketplace)
      idempotency_key = order.id
      location_id = marketplace.square_location_id
      customer_id = order.shopper.id
      line_items = order.products.map { |product|
        {
          name: product.name,
          quantity: 1,
          item_type: "ITEM", # ITEM|CUSTOM_AMOUNT|CGI
          base_price_money: {
            amount: product.price_cents,
            currency: product.price_currency
          }
        }
      }

      required_params = {
        order: {
          location_id: location_id,
          line_items: line_items,
          fulfillments: [
            {
              type: "DELIVERY", # DELIVERY|SHIPMENT|PICKUP
              state: "PROPOSED", # PROPOSED|RESERVED|PREPARED|COMPLETED|CANCELED|FAILED
              delivery_details: {
                recipient: {
                  display_name: order.shopper.name,
                  phone_number: order.contact_phone,
                  address: order.delivery_address
                },
                schedule_type: "SCHEDULED", # SCHEDULED|ASAP
                deliver_at: DateTime.rfc3339(
                  # TODO
                  # Square requires this field. Until we have a delivery
                  # calculation, let's use `now`.
                  DateTime.now
                )
              }
            }
          ]
        },
        idempotency_key: idempotency_key
      }
      optional_params = {
        customer_id: customer_id
      }
      required_params.merge(optional_params)
    end

    def build_square_create_order_payment_body(order, marketplace, balance_transaction)
      {
        source_id: "cnon:card-nonce-ok",
        idempotency_key: order.idempotency_key,
        amount_money: {
          amount: balance_transaction.amount,
          currency: balance_transaction.currency
        },
        order_id: order.id,
        location_id: marketplace.location_id
      }
    end
  end
end
