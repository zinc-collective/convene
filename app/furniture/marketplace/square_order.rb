# SquareOrder encapsulates logic for coordinating and executing interactions
# between a Convene Marketplace and the seller's Square account. It could be
# described as a (budding) service or process class, but current behavior is
# limited to only registering orders in a seller's account upon sale.
#
# Registering orders serves to both synchronize record keeping between
# Marketplace managers owners (eg. Pikkkup) and sellers (eg. Crumble & Wisk)
# and automatically notify sellers of new orders.
#
# NOTE: the simple `Markeplace > SquareOrder` namespacing was chosen
# to avoid collision with the `Square` namespace already included by Square's gem.
#
# TODOS/considerations:
# 1. Implement validation of `order` argument on initialization
#   Eg: if order.is_not_valid?; exit; end
# 2. Implement state tracking
#   Eg: READY | ORDER_SENT | etc...
class Marketplace
  class SquareOrder
    attr_accessor :order, :square_order_id, :square_payment_id
    delegate :shopper, :marketplace, :ordered_products, to: :order
    delegate :space, :square_location_id, to: :marketplace

    def initialize(square_client)
      @square_client ||= square_client
    end

    # Sends an order to Square. Will create both an order and payment in the
    # receiving account which are requirements for the order to show up in the
    # Seller Dashboard.
    def send_order(order, stripe_charge_id)
      @order = order
      @stripe_charge_id = stripe_charge_id
      square_create_order_response = create_square_order
      order.events.create(description: "Square Order Created")

      if square_create_order_response
        @square_order_id = square_create_order_response.body.order[:id]
        square_create_payment_response = create_square_order_payment
        order.events.create(description: "Square Payment Created")
        @square_payment_id = square_create_payment_response.body.payment[:id]
        # @state = "ORDER_SENT"

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
      @key ||= SquareIdempotencyKey.generate(@order)
    end

    private def create_square_order
      square_create_order_body = prepare_square_create_order_body
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
      location_id = marketplace.square_location_id
      customer_id = shopper.id

      line_items = ordered_products.map { |ordered_product|
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

      taxes = marketplace.tax_rates.map { |tax_rate|
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
                  display_name: shopper.person.display_name,
                  phone_number: order.contact_phone_number,
                  address: {
                    address_line_1: order.delivery_address
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
          amount: order.product_total.cents,
          currency: "USD"
        },
        order_id: @square_order_id,
        location_id: @square_location_id,
        external_details: {
          type: "OTHER",
          source: "Paid by Stripe (Charge #{@stripe_charge_id}) via #{space.name} (#{space.id})"
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
