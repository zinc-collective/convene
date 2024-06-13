# Renders a tile with a link to view the Marketplace Stripe account page
class Marketplace::StripeOverviewComponent < ApplicationComponent
  attr_accessor :marketplace
  delegate :stripe_utility, to: :marketplace, prefix: true

  def initialize(marketplace:, **)
    super(**)

    @marketplace = marketplace
  end
end
