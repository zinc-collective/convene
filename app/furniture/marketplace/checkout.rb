class Marketplace
  class Checkout < ApplicationRecord
    self.table_name = "marketplace_checkouts"
    include WithinLocation
    self.location_parent = :marketplace

    belongs_to :cart, inverse_of: :checkout
    delegate :marketplace, to: :cart

    has_many :ordered_products, through: :cart, source: :cart_products, class_name: "Marketplace::OrderedProduct"

    belongs_to :shopper, inverse_of: :checkouts

    # It would be nice to validate instead the presence of :ordered_products, but my attempts at this raise:
    #  ActiveRecord::HasManyThroughCantAssociateThroughHasOneOrManyReflection:
    #   Cannot modify association 'Marketplace::Checkout#ordered_products' because the source reflection class 'CartProduct' is associated to 'Cart' via :has_many.
    validates :stripe_line_items, presence: true

    enum status: {
      pre_checkout: "pre_checkout",
      paid: "paid"
    }

    def self.model_name
      @_model_name ||= ActiveModel::Name.new(self, ::Marketplace)
    end

    def create_stripe_session(success_url:, cancel_url:)
      Stripe::Checkout::Session.create({
        line_items: stripe_line_items,
        mode: "payment",
        success_url: success_url,
        cancel_url: cancel_url,
        payment_intent_data: {
          transfer_group: id
        }
      }, {
        api_key: marketplace.stripe_api_key
      })
    end

    def complete(stripe_session_id:)
      update!(status: :paid, stripe_session_id: stripe_session_id)
      cart.update!(status: :checked_out)
    end

    private

    def stripe_line_items
      return [] unless cart.present?

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
  end
end
