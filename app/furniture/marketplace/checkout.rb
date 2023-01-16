class Marketplace
  class Checkout < ApplicationRecord
    self.table_name = "marketplace_checkouts"
    include WithinLocation
    self.location_parent = :marketplace

    belongs_to :cart, inverse_of: :checkout
    has_many :ordered_products, through: :cart, source: :cart_products, class_name: "Marketplace::OrderedProduct"
    delegate :marketplace, to: :cart
    belongs_to :shopper, inverse_of: :checkouts

    # It would be nice to validate instead the presence of :ordered_products, but my attempts at this raise:
    #  ActiveRecord::HasManyThroughCantAssociateThroughHasOneOrManyReflection:
    #   Cannot modify association 'Marketplace::Checkout#ordered_products' because the source reflection class 'CartProduct' is associated to 'Cart' via :has_many.
    validates :stripe_line_items, presence: true
    validate :stripe_checkout_session, if: :pre_checkout?

    attr_accessor :stripe_success_url, :stripe_cancel_url

    enum status: {
      pre_checkout: "pre_checkout",
      paid: "paid",
    }

    def self.model_name
      @_model_name ||= ActiveModel::Name.new(self, ::Marketplace)
    end

    def stripe_redirect_url
      @stripe_checkout_session&.url
    end

    private

    def stripe_checkout_session
      return unless cart.present?

      begin
        @stripe_checkout_session = Stripe::Checkout::Session.create({
          line_items: stripe_line_items,
          mode: "payment",
          success_url: stripe_success_url,
          cancel_url: stripe_cancel_url
        }, {
          api_key: marketplace.stripe_api_key
        })
      rescue Stripe::StripeError => err
        errors.add(:base, "Stripe error: #{err.message}")
      end
    end

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
          adjustable_quantity: { enabled: true }
        }
      end
    end
  end
end
