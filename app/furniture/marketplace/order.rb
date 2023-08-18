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

    def send_to_square_seller_dashboard(stripe_balance_transaction)
      square_client = Square::Client.new(
        access_token: marketplace.square_access_token,
        environment: "sandbox"
      )

      square_create_order_body = build_square_create_order_body(marketplace)
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
    end

    def build_square_create_order_body(marketplace)
      idempotency_key = SecureRandom.uuid
      location_id = marketplace.settings["square_location_id"]
      customer_id = shopper.id
      line_items = ordered_products.map { |ordered_product|
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

      {
        order: {
          location_id: location_id,
          line_items: line_items,
          fulfillments: [
            {
              type: "DELIVERY", # DELIVERY|SHIPMENT|PICKUP
              state: "PROPOSED", # PROPOSED|RESERVED|PREPARED|COMPLETED|CANCELED|FAILED
              delivery_details: {
                recipient: {
                  display_name: shopper.person.name || "TESTNAME",  # TODO: Missing name?
                  phone_number: contact_phone_number,
                  address: {
                    address_line_1: delivery_address
                  }
                },
                schedule_type: "SCHEDULED", # SCHEDULED|ASAP
                # TODO
                # Square requires this field. Until we have a delivery
                # calculation, let's use `now`?
                deliver_at: Time.now.to_datetime.rfc3339
              }
            }
          ],
          customer_id: customer_id
        },
        idempotency_key: idempotency_key
      }
    end

    def build_square_create_order_payment_body(square_order_id, square_location_id, space_id, balance_transaction)
      idempotency_key = SecureRandom.uuid
      {
        source_id: "EXTERNAL",
        idempotency_key: idempotency_key,
        amount_money: {
          # TODO: FIXTURE
          amount: 4000,
          currency: "USD"
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
