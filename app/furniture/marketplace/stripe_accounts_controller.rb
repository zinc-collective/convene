class Marketplace
  class StripeAccountsController < Controller
    def create
      authorize(marketplace, :edit?)
      stripe_account_link = marketplace.stripe_account_link(
        refresh_url: polymorphic_url(marketplace.location(:edit)),
        return_url: polymorphic_url(marketplace.location(:edit))
      )

      marketplace.create_stripe_webhook_endpoint(webhook_url: polymorphic_url(marketplace.location(child: :stripe_events)))

      redirect_to stripe_account_link.url, status: :see_other, allow_other_host: true
    rescue Stripe::InvalidRequestError => e
      redirect_to marketplace.location(:edit), alert: "Something went wrong! #{e.message}"
    end

    def new
      authorize(marketplace, :edit?)
      redirect_to marketplace.location(child: :stripe_account)
    end

    def show
      authorize(marketplace, :edit?)
    end
  end
end
