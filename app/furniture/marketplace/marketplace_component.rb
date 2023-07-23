class Marketplace
  class MarketplaceComponent < ApplicationComponent
    include CurrentPerson

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
      @cart ||= carts.create_with(contact_email: shopper.person&.email).find_or_create_by(shopper: shopper, status: :pre_checkout)
    end

    def onboarding_component
      OnboardingComponent.new(marketplace: marketplace, current_person: current_person)
    end

    def shopper
      current_person.find_or_create_shopper
    end
  end
end
