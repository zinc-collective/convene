class Marketplace
  class StripeAccountsController < FurnitureController
    def create
      authorize(marketplace, :edit?)
      account = Stripe::Account.create({type: "standard"}, {
        api_key: marketplace.stripe_api_key
      })
      account_link = Stripe::AccountLink.create(
        {
          account: account.id,
          refresh_url: "https://example.com/reauth",
          return_url: "https://example.com/return",
          type: "account_onboarding"
        },
        {
          api_key: marketplace.stripe_api_key
        }
      )
      redirect_to account_link.url, status: :see_other, allow_other_host: true
    end

    helper_method def marketplace
      @marketplace ||= policy_scope(Marketplace).find(params[:marketplace_id])
    end
  end
end
