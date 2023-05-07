class Marketplace
  class MarketplaceComponent < ApplicationComponent
    attr_accessor :marketplace
    delegate :location, :carts, :ready_for_shopping?, to: :marketplace

    def initialize(marketplace:, data: {}, classes: "", **kwargs)
      super(data: data, classes: classes, **kwargs)
      self.marketplace = marketplace
    end

    def render?
      ready_for_shopping? || policy(marketplace).edit?
    end

    def cart
      @cart ||= carts.create_with(contact_email: shopper.person&.email).find_or_create_by(shopper: shopper, status: :pre_checkout)
    end

    def shopper
      if current_person.is_a?(Guest)
        Shopper.find_or_create_by(id: session[:guest_shopper_id] ||= SecureRandom.uuid)
      else
        Shopper.find_or_create_by(person: current_person)
      end
    end
  end
end
