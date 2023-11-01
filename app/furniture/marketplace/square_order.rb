# SquareOrder is a service class for coordinating and executing interactions
# between a Convene Marketplace and a seller's Square account.
#
# Current behavior is limited to registering orders in a seller's account upon
# sale so that we help synchronize record keeping for Marketplace owners and
# sellers.
#
# NOTE: the simple `Markeplace > SquareOrder` namespacing was chosen
# to avoid collision with the `Square` namespace already included by Square's gem.
class Marketplace
  class SquareOrder
    def initialize(order)
      @order = order
      @marketplace = order.marketplace
      @shopper = order.shopper
      @space = order.marketplace.space
      @ordered_products = @order.ordered_products
      @square_location_id = @marketplace.settings["square_location_id"]
      @square_order_id = nil
      @square_payment_id = nil
    end

    # Sends an order to Square. Will create both an order and payment in the
    # receiving account which are requirements for the order to show up in the
    # Seller Dashboard.
    def send_order
      square_create_order_response = create_square_order

      if square_create_order_response
        @square_order_id = square_create_order_response.body.order[:id]
        square_create_payment_response = create_square_order_payment
        @square_payment_id = square_create_payment_response.body.payment[:id]

        # This data is intended for use in debugging, etc... until we further
        # the Square integration productize
        {
          order_id: @square_order_id,
          payment_id: @square_payment_id
        }
      else
        # TODO: Noop for now
      end
    end

    # Square sets max of 43 chars so this assumes an order id remains a 36-char
    # uuid
    private def square_idemp_key
      "#{@order.id}_#{8.times.map { rand(10) }.join}"
    end

    private def create_square_order
      square_create_order_body = prepare_square_create_order_body(@marketplace)
      @square_client.orders.create_order(body: square_create_order_body)
    end

    # NOTE: Square requires that orders must have be in a state of complete
    # payment to display in the Seller Dashboard
    private def create_square_order_payment
      square_create_payment_body = prepare_square_create_order_payment_body

      @square_client.payments.create_payment(body: square_create_payment_body)
    end

    # NOTE: Square requires that orders must include fulfillments to display
    # in the Seller Dashboard
    # See: https://developer.squareup.com/docs/orders-api/create-orders
    private def prepare_square_create_order_body
      location_id = @marketplace.settings["square_location_id"]
      customer_id = @shopper.id

      line_items = @ordered_products.map { |ordered_product|
        {
          name: ordered_product.name,
          quantity: ordered_product.quantity.to_s,
          item_type: "ITEM", # ITEM|CUSTOM_AMOUNT|CGI
          base_price_money: {
            amount: ordered_product.product.price.cents,
            currency: "USD"
          }
        }
      }

      taxes = @marketplace.tax_rates.map { |tax_rate|
        {
          uid: tax_rate.id,
          name: tax_rate.label,
          percentage: tax_rate.tax_rate.to_s,
          scope: "LINE_ITEM"
        }
      }

      {
        order: {
          location_id:,
          line_items:,
          taxes:,
          fulfillments: [
            {
              type: "DELIVERY", # DELIVERY|SHIPMENT|PICKUP
              state: "PROPOSED", # PROPOSED|RESERVED|PREPARED|COMPLETED|CANCELED|FAILED
              delivery_details: {
                recipient: {
                  display_name: @shopper.person.display_name,
                  phone_number: @order.contact_phone_number,
                  address: {
                    address_line_1: @order.delivery_address
                  }
                },
                schedule_type: "SCHEDULED", # SCHEDULED|ASAP
                # Square requires this field. Until we have a delivery
                # calculation, let's put `now`?
                deliver_at: Time.now.to_datetime.rfc3339
              }
            }
          ],
          customer_id:
        },
        idempotency_key: square_idemp_key
      }
    end

    # NOTE: For payments that are received outside of Square - such as Convene
    # orders paid with Stripe --  Square recommends putting "EXTERNAL" for the
    # `source_id` and "OTHER" for the `external_details.type`.
    # See: https://developer.squareup.com/docs/payments-api/take-payments/external-payments
    #
    # NOTE: `amount_money` much match the price total of line items in the
    # square order (`line_items.sum(&base_price_money[:amount])`) to be valid
    #
    # TODO: Consider adding a price check?
    private def prepare_square_create_order_payment_body
      {
        source_id: "EXTERNAL",
        idempotency_key: square_idemp_key,
        amount_money: {
          amount: @order.product_total.cents,
          currency: "USD"
        },
        order_id: @square_order_id,
        location_id: @square_location_id,
        external_details: {
          type: "OTHER",
          source: "CONVENE_SYSTEM_PAYMENT for Space #{@space.id}"
          # TODO: Need this later?
          # source_fee_money: {
          #   amount: "test",
          #   currency: "test"
          # }
        }
      }
    end
  end
end
