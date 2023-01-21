# frozen_string_literal: true

class Marketplace
  class Marketplace < FurniturePlacement
    self.location_parent = :room

    has_many :products, inverse_of: :marketplace, dependent: :destroy
    has_many :carts, inverse_of: :marketplace, dependent: :destroy
    has_many :orders, inverse_of: :marketplace

    # The Secret Stripe API key belonging to the owner of the Marketplace
    def stripe_api_key=(key)
      settings["stripe_api_key"] = key
    end

    def stripe_api_key
      settings["stripe_api_key"]
    end

    def self.model_name
      @_model_name ||= ActiveModel::Name.new(self, ::Marketplace)
    end
  end
end
