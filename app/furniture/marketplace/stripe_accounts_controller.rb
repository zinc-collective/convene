class Marketplace
  class StripeAccountsController < FurnitureController
    def create
      # TODO: Should we be using https://stripe.com/docs/connect/oauth-express-accounts instead?!
      authorize(marketplace, :edit?)
      account = if marketplace.stripe_account.blank?
        Stripe::Account.create({type: "standard"}, {
          api_key: marketplace.stripe_api_key
        }).tap do
          marketplace.update(stripe_account: account.id)
        end
      else
        Stripe::Account.find(marketplace.stripe_api_key)
      end

      account_link = if account.details_submitted?
        Stripe::AccountLink.create(
          {
            account: marketplace.stripe_account_id,
            refresh_url: polymorphic_url(marketplace.location(:edit)),
            return_url: polymorphic_url(marketplace.location(:edit)),
            type: "account_update"
          },
          {
            api_key: marketplace.stripe_api_key
          }
        )
      else
         Stripe::AccountLink.create(
          {
            account: marketplace.stripe_account_id,
            refresh_url: polymorphic_url(marketplace.location(:edit)),
            return_url: polymorphic_url(marketplace.location(:edit)),
            type: "account_onboarding"
          },
          {
            api_key: marketplace.stripe_api_key
          }
        )
      end
      redirect_to account_link.url, status: :see_other, allow_other_host: true
    end

    helper_method def marketplace
      @marketplace ||= policy_scope(Marketplace).find(params[:marketplace_id])
    end
  end
end
