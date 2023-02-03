# frozen_string_literal: true

class Marketplace
  class Marketplace < FurniturePlacement
    self.location_parent = :room

    has_many :products, inverse_of: :marketplace, dependent: :destroy
    has_many :carts, inverse_of: :marketplace, dependent: :destroy
    has_many :orders, inverse_of: :marketplace

    # The Secret Stripe API key belonging to the owner of the Marketplace
    def stripe_api_key
      space.utility_hookups.find_by!(utility_slug: :stripe).utility.api_token
    end

    def stripe_account
      settings["stripe_account"]
    end

    def stripe_account=stripe_account
      settings["stripe_account"] = stripe_account
    end


    def stripe_webhook_endpoint
      settings["stripe_webhook_endpoint"]
    end

    def stripe_webhook_endpoint=stripe_webhook_endpoint
      settings["stripe_webhook_endpoint"] = stripe_webhook_endpoint
    end

    def delivery_fee_cents= delivery_fee_cents
      settings["delivery_fee_cents"] = delivery_fee_cents
    end

    def delivery_fee_cents
      settings["delivery_fee_cents"] || 0
    end
    monetize :delivery_fee_cents

    def stripe_account_link(refresh_url:, return_url:)
      account = if stripe_account.blank?
        Stripe::Account.create({type: "standard"}, {
          api_key: stripe_api_key
        }).tap do |account|
          update(stripe_account: account.id)
        end
      else
        Stripe::Account.retrieve(stripe_account, {
          api_key: stripe_api_key
        })
      end

      Stripe::AccountLink.create({
        account: stripe_account,
        refresh_url: refresh_url,
        return_url: return_url,
        type: account.details_submitted? ? "account_update" : "account_onboarding"
      }, {
        api_key: stripe_api_key
      })
    end

    def create_stripe_webhook_endpoint(webhook_url:)
      Stripe::WebhookEndpoint.create({
        enabled_events: ["checkout.session.completed"],
        url: webhook_url
      }, { api_key: stripe_api_key }).tap do |stripe_webhook_endpoint|
        update(stripe_webhook_endpoint: stripe_webhook_endpoint.id)
      end
    end

    def self.model_name
      @_model_name ||= ActiveModel::Name.new(self, ::Marketplace)
    end
  end
end
