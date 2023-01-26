class Marketplace
  class StripeAccountsController < FurnitureController
    def create
      # TODO: Should we be using https://stripe.com/docs/connect/oauth-express-accounts instead?!
      authorize(marketplace, :edit?)
      stripe_account_link = marketplace.stripe_account_link(
        refresh_url: polymorphic_url(marketplace.location(:edit)),
        return_url: polymorphic_url(marketplace.location(:edit))
      )
      redirect_to stripe_account_link.url, status: :see_other, allow_other_host: true
    end

    helper_method def marketplace
      @marketplace ||= policy_scope(Marketplace).find(params[:marketplace_id])
    end
  end
end
