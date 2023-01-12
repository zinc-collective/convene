class Marketplace
  class Checkout < ApplicationRecord
    self.table_name = "marketplace_checkouts"
    include WithinLocation
    self.location_parent = :marketplace

    belongs_to :cart, inverse_of: :checkout
    has_many :ordered_products, through: :cart, source: :cart_products, class_name: "Marketplace::OrderedProduct"
    delegate :marketplace, to: :cart
    belongs_to :shopper, inverse_of: :checkouts

    enum status: {
      pre_checkout: "pre_checkout",
      paid: "paid",
    }

    def self.model_name
      @_model_name ||= ActiveModel::Name.new(self, ::Marketplace)
    end
  end
end
