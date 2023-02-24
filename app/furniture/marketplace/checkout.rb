class Marketplace
  class Checkout < Model
    self.location_parent = :cart
    include ActiveModel::Validations
    attr_accessor :cart
    delegate :shopper, :marketplace, :persisted?, to: :cart

    # It would be nice to validate instead the presence of :ordered_products, but my attempts at this raise:
    #  ActiveRecord::HasManyThroughCantAssociateThroughHasOneOrManyReflection:
    #   Cannot modify association 'Marketplace::Checkout#ordered_products' because the source reflection class 'CartProduct' is associated to 'Cart' via :has_many.
    validates :stripe_cart_products_line_items, presence: true

    def create_stripe_session(success_url:, cancel_url:)
      Stripe::Checkout::Session.create({
        line_items: stripe_line_items,
        mode: "payment",
        success_url: success_url,
        cancel_url: cancel_url,
        shipping_address_collection: {
          allowed_countries: ["US"],
        },
        payment_intent_data: {
          transfer_group: cart.id
        }
      }, {
        api_key: marketplace.stripe_api_key
      })
    end

    private

    def stripe_line_items
      return [] if cart.blank?

      stripe_cart_products_line_items + stripe_delivery_fee_line_items
    end

    private def stripe_cart_products_line_items
      cart.cart_products.map do |cart_product|
        {
          price_data: {
            currency: "USD",
            unit_amount: cart_product.product.price_cents,
            product_data: {name: cart_product.product.name}
          },
          quantity: cart_product.quantity,
          adjustable_quantity: {enabled: true}
        }
      end
    end

    private def stripe_delivery_fee_line_items
      [
        {quantity: 1,
         price_data: {
           currency: "USD",
           unit_amount: marketplace.delivery_fee_cents,
           product_data: {name: "Delivery"}
         }}
      ]
    end
  end
end
