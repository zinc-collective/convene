class Marketplace
  class Order < Record
    self.table_name = "marketplace_orders"
    location(parent: :marketplace)

    belongs_to :marketplace, inverse_of: :orders
    delegate :space, :room, to: :marketplace

    belongs_to :delivery_area, inverse_of: :orders, optional: true

    belongs_to :shopper, inverse_of: :orders

    has_many :ordered_products, inverse_of: :order, foreign_key: :cart_id, dependent: :destroy
    has_many :products, through: :ordered_products, inverse_of: :orders
    has_many :events, inverse_of: :regarding, dependent: :destroy, as: :regarding

    has_encrypted :delivery_address
    has_encrypted :contact_phone_number
    has_encrypted :contact_email

    enum status: {
      pre_checkout: "pre_checkout",
      paid: "paid"
    }

    monetize :payment_processor_fee_cents
    def vendors_share
      product_total - payment_processor_fee
    end

    def product_total
      ordered_products.sum(0, &:price_total)
    end

    def tax_total
      ordered_products.sum(0, &:tax_amount)
    end

    def delivery
      becomes(Delivery)
    end

    def delivery_fee
      delivery_area&.price
    end
    delegate :delivery_window, to: :delivery_area, allow_nil: true

    def marketplace_name
      marketplace.room.name
    end

    def price_total
      [product_total, delivery_fee, tax_total].compact.sum
    end

	# TODO: Add `square_environment` attribute to database/model
    def square_client
      @square_client ||= Square::Client.new(access_token: marketplace.square_access_token, environment: marketplace.square_environment)
    end

    def send_to_square_seller_dashboard
      square_create_order_response = create_square_order
      square_create_payment_response = create_square_order_payment(square_create_order_response.body.order[:id])

      # This data is intended for use in debugging, etc... until we further
      # the Square integration productize
      {
        order_id: square_create_order_response.body.order[:id],
        payment_id: square_create_payment_response.body.payment[:id]
      }
    end

    # Square sets max of 43 chars
    private def square_idemp_key
      "#{id}_#{8.times.map { rand(10) }.join}"
    end

    private def create_square_order
      square_create_order_body = build_square_create_order_body(marketplace)
      square_client.orders.create_order(body: square_create_order_body)
    end

    # NOTE: Square requires that orders are paid in order to show up in the Seller
    # Dashboard
    private def create_square_order_payment(square_order_id)
      square_location_id = marketplace.settings["square_location_id"]
      space_id = marketplace.space.id
      square_create_payment_body = build_square_create_order_payment_body(
        square_order_id,
        square_location_id,
        space_id
      )

      @square_client.payments.create_payment(body: square_create_payment_body)
    end

    # NOTE: Square requires that orders include fulfillments in order to show up
    # in the Seller Dashboard
    # See: https://developer.squareup.com/docs/orders-api/create-orders
    private def build_square_create_order_body(marketplace)
      location_id = marketplace.settings["square_location_id"]
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
                  phone_number: contact_phone_number,
                  address: {
                    address_line_1: delivery_address
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
    private def build_square_create_order_payment_body(square_order_id, square_location_id, space_id)
      {
        source_id: "EXTERNAL",
        idempotency_key: square_idemp_key,
        amount_money: {
          amount: product_total.cents,
          currency: "USD"
        },
        order_id: square_order_id,
        location_id: square_location_id,
        external_details: {
          type: "OTHER",
          source: "CONVENE_SYSTEM_PAYMENT for Space #{space_id}"
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
