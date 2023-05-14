# frozen_string_literal: true

class Marketplace
  class Marketplace < Furniture
    location(parent: :room)
    default_scope { where(furniture_kind: "marketplace") }

    has_one :space, through: :room, inverse_of: :furnitures
    has_one :bazaar, through: :room, inverse_of: :furnitures, source: :space, class_name: "Bazaar"
    has_many :tax_rates, inverse_of: :marketplace

    has_many :products, inverse_of: :marketplace, dependent: :destroy
    has_many :carts, inverse_of: :marketplace, dependent: :destroy
    has_many :orders, inverse_of: :marketplace

    has_many :delivery_areas, inverse_of: :marketplace, dependent: :destroy

    setting :notify_emails
    setting :stripe_account
    alias_method :vendor_stripe_account, :stripe_account
    setting :stripe_webhook_endpoint
    setting :stripe_webhook_endpoint_secret

    def has_controller_edit?
      true
    end

    def ready_for_shopping?
      products.present? && stripe_api_key? && delivery_areas.present? && stripe_account_connected?
    end

    # The Secret Stripe API key belonging to the owner of the Marketplace
    def stripe_api_key
      space.utilities.find_by!(utility_slug: :stripe).utility.api_token
    end

    def stripe_api_key?
      stripe_api_key.present?
    rescue ActiveRecord::RecordNotFound
      false
    end

    def stripe_account_connected?
      stripe_account.present? && stripe_webhook_endpoint.present? && stripe_webhook_endpoint_secret.present?
    end

    # @raises Stripe::InvalidRequestError if something is sad
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
      return if stripe_webhook_endpoint.present?

      Stripe::WebhookEndpoint.create({
        enabled_events: ["checkout.session.completed"],
        url: webhook_url
      }, {api_key: stripe_api_key}).tap do |stripe_webhook_endpoint|
        update(stripe_webhook_endpoint: stripe_webhook_endpoint.id, stripe_webhook_endpoint_secret: stripe_webhook_endpoint.secret)
      end
    end

    def self.model_name
      @_model_name ||= ActiveModel::Name.new(self, ::Marketplace)
    end
  end
end
