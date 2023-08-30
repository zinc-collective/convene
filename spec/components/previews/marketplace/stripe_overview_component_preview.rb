# frozen_string_literal: true

class Marketplace::StripeOverviewComponentPreview < ViewComponent::Preview
  def default
    render(Marketplace::StripeOverviewComponent.new)
  end
end
