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

      account_link = if account.details_submitted?
        Stripe::AccountLink.create(
          {
            account: stripe_account,
            refresh_url: refresh_url,
            return_url: return_url,
            type: "account_update"
          },
          {
            api_key: stripe_api_key
          }
        )
      else
        Stripe::AccountLink.create(
          {
            account: stripe_account,
            refresh_url: refresh_url,
            return_url: return_url,
            type: "account_onboarding"
          },
          {
            api_key: stripe_api_key
          }
        )
      end
    end

    def self.model_name
      @_model_name ||= ActiveModel::Name.new(self, ::Marketplace)
    end
  end
end
