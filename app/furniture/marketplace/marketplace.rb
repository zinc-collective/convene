# frozen_string_literal: true

class Marketplace
  class Marketplace < Furniture
    location(parent: :room)
    default_scope { where(furniture_kind: "marketplace") }

    has_one :bazaar, through: :room, inverse_of: :gizmos, source: :space, class_name: "Bazaar"
    # @todo replace with through :bazaar
    has_many :tax_rates, inverse_of: :marketplace

    has_many :tags, through: :bazaar

    has_many :products, inverse_of: :marketplace, dependent: :destroy
    has_many :carts, inverse_of: :marketplace, dependent: :destroy
    has_many :orders, inverse_of: :marketplace

    has_many :delivery_areas, inverse_of: :marketplace, dependent: :destroy

    has_many :notification_methods, inverse_of: :marketplace, dependent: :destroy
    has_many :vendor_representatives, inverse_of: :marketplace, dependent: :destroy

    setting :stripe_account
    alias_method :vendor_stripe_account, :stripe_account
    setting :stripe_webhook_endpoint
    setting :stripe_webhook_endpoint_secret
    setting :square_environment

    # Square order notifications integration
    setting :square_location_id

    def cart_for_shopper(shopper:, cart_status: :pre_checkout)
      carts.find_by(shopper:, status: cart_status) || carts.create(
        shopper: shopper,
        contact_email: shopper.person&.email,
        delivery_area: default_delivery_area,
        status: cart_status
      )
    end

    def square_access_token=square_access_token
      secrets["square_access_token"] = square_access_token
    end

    def square_access_token
      secrets && secrets["square_access_token"]
    end

    def has_controller_edit?
      true
    end

    def flyer
      Flyer.new(self)
    end

    def ready_for_shopping?
      products.present? && stripe_api_key? && delivery_areas.present? && stripe_account_connected?
    end

    def stripe_utility
      @stripe_utility ||= space.utilities.find_by(utility_slug: :stripe)&.utility
    end

    # The Secret Stripe API key belonging to the owner of the Marketplace
    def stripe_api_key
      stripe_utility&.api_token
    end

    def stripe_api_key?
      stripe_api_key.present?
    rescue ActiveRecord::RecordNotFound
      false
    end

    def in_room_template
      "marketplace/in_room_template"
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

    def square_connection
      if square_order_notifications_enabled?
        SquareOrder.new(Square::Client.new(
          access_token: square_access_token,
          environment: square_environment
        ))
      end
    end

    def square_order_notifications_enabled?
      square_location_id.present? && square_access_token.present?
    end

    def default_delivery_area
      (delivery_areas.unarchived.size == 1) ? delivery_areas.unarchived.first : nil
    end

    # Because we've decided to make tagging or assigning to group optional for
    # Marketplace Products, we need a method for querying these non-tagged
    # Products for display
    def products_with_no_group_tags
      # A rough mental model of this query
      #
      # Step 1: Build a list of unarchived marketplace products represented by
      # an array of boolean markers that map to the "is_group" column for each
      # of their respective tags.
      #
      # | mp_tag_groups |
      # | ------------- |
      # | {t, f, t, f}  | <-- has some group tags
      # | {f, f}        | <-- has no group tags
      # | {t, t, t}     | <-- has all group tags
      #
      # Step 2: Filter this list and return only the Marketplace Products who's
      # corresonding row includes all `f`s.
      with_no_group_tags = Product.find_by_sql <<-SQL.squish
        select
            mp.*
        from
            marketplace_products mp
            full join marketplace_product_tags mpt on mpt.product_id = mp.id
            full join marketplace_tags mt on mt.id = mpt.tag_id
        where
            mp.marketplace_id = '#{id}'
            and mp.discarded_at is null
        group by
            mp.id
        having not
            't' = any(array_agg(mt.is_group));
      SQL

      # Step 3: Merge the above with all other products that are missing tags
      # which won't be captured by the above query
      with_no_group_tags + products.unarchived.where.missing(:tags)
    end
  end
end
