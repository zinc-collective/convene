# Renders a tile with a link to view the Marketplace Stripe account page
class Marketplace::StripeOverviewComponent < ApplicationComponent
  attr_accessor :marketplace
  attr_accessor :marketplace_stripe_utility

  def initialize(marketplace:, **kwargs)
    super(**kwargs)

    @marketplace = marketplace
    @marketplace_stripe_utility = marketplace.stripe_utility
  end
end
