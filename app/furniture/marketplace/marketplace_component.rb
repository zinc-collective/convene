class Marketplace
  class MarketplaceComponent < ApplicationComponent
    attr_accessor :marketplace
    delegate :location, :carts, :ready_for_shopping?, to: :marketplace

    def initialize(marketplace:, **kwargs)
      super(**kwargs)
      self.marketplace = marketplace
    end

    def render?
      ready_for_shopping? || policy(marketplace).edit?
    end

    def cart
      delivery_area = marketplace.delivery_areas.first if marketplace.delivery_areas.size == 1
      @cart ||= carts.create_with(contact_email: shopper.person&.email).find_or_create_by(delivery_area: delivery_area, shopper: shopper, status: :pre_checkout)
    end

    def delivery_area_component
      @delivery_area_component ||= Cart::DeliveryAreaComponent.new(cart: cart)
    end

    def onboarding_component
      OnboardingComponent.new(marketplace: marketplace, current_person: current_person)
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
