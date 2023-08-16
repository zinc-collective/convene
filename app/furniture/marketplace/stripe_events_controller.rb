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
        # payment_intent = Stripe::PaymentIntent.retrieve(event.data.object.payment_intent, {api_key: marketplace.stripe_api_key})

        order = marketplace.orders.find_by(id: "15e346c8-e42b-4a67-a991-35870db766e1")

        return if order.nil?

        # latest_charge = Stripe::Charge.retrieve(payment_intent.latest_charge, api_key: marketplace.stripe_api_key)
        # balance_transaction = Stripe::BalanceTransaction.retrieve(latest_charge.balance_transaction, api_key: marketplace.stripe_api_key)

        order.update!(status: :paid, placed_at: DateTime.now, payment_processor_fee_cents: 1000)
        order.events.create(description: "Payment Received")

        square_client = Square::Client.new(
          access_token: marketplace.square_access_token,
          environment: "sandbox"
        )

        square_create_order_body = build_square_create_order_body(order, marketplace)
        square_create_order_response = square_client.orders.create_order(body: square_create_order_body)
        square_order_id = square_create_order_response.body.order[:id]
        square_location_id = marketplace.settings["square_location_id"]
        space_id = marketplace.space.id
        square_create_payment_body = build_square_create_order_payment_body(
          square_order_id,
          square_location_id,
          space_id,
          {}
        )

        # DEV NOTE: Square requires that orders are paid in order to show up in the Seller Dashboard
        # TODO: Need response object?
        square_create_payment_response = square_client.payments.create_payment(body: square_create_payment_body)

        # Order::ReceivedMailer.notification(order).deliver_later
        # order.events.create(description: "Notifications to Vendor and Distributor Sent")
        # Order::PlacedMailer.notification(order).deliver_later
        # order.events.create(description: "Notification to Buyer Sent")

        # Stripe::Transfer.create({
        #   # Leave the Stripe Fees in the `Distributor`'s account
        #   amount: order.product_total.cents - balance_transaction.fee,
        #   currency: "usd",
        #   destination: marketplace.vendor_stripe_account,
        #   transfer_group: order.id
        # }, {api_key: marketplace.stripe_api_key})
        # order.events.create(description: "Payment Split")
      else
        # raise UnexpectedStripeEventTypeError, event.type
      end
    end

    def build_square_create_order_body(order, marketplace)
      idempotency_key = SecureRandom.uuid
      location_id = marketplace.settings["square_location_id"]
      customer_id = order.shopper.id
      line_items = order.ordered_products.map { |ordered_product|
        {
          name: ordered_product.name,
          quantity: ordered_product.quantity.to_s,
          item_type: "ITEM", # ITEM|CUSTOM_AMOUNT|CGI
          base_price_money: {
            amount: ordered_product.price_cents,
            currency: ordered_product.product.price_currency
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
                  display_name: order.shopper.person.name || "TESTNAME",  # TODO: Missing name?
                  phone_number: order.contact_phone_number,
                  address: {
                    address_line_1: order.delivery_address
                  }
                },
                schedule_type: "SCHEDULED", # SCHEDULED|ASAP
                # TODO
                # Square requires this field. Until we have a delivery
                # calculation, let's use `now`.
                deliver_at: Time.now.to_datetime.rfc3339
              }
            }
          ],
          customer_id: customer_id
        },
        idempotency_key: idempotency_key
      }
      puts "DDDDDDDDDDDDDDD"

      required_params
    end

    def build_square_create_order_payment_body(square_order_id, square_location_id, space_id, balance_transaction)
      idempotency_key = SecureRandom.uuid
      {
        source_id: "EXTERNAL",
        idempotency_key: idempotency_key,
        amount_money: {
          amount: balance_transaction.amount,
          currency: balance_transaction.currency
        },
        order_id: square_order_id,
        location_id: square_location_id,
        external_details: {
          type: "OTHER",
          source: "CONVENE_SYSTEM_PAYMENT for Space #{space_id}"
          # TODO: Want this?
          # source_fee_money: {
          #   amount: "test",
          #   currency: "test"
          # }
        }
      }
    end
  end
end
