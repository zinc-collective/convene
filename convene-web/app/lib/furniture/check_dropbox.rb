# frozen_string_literal: true

module Furniture
  # Allows a Space to receive eChecks
  # @see features/furniture/check-drop-off.feature
  class CheckDropbox
    include Placeable

    def self.append_routes(router)
      router.scope module: 'check_dropbox' do
        router.resource :check_dropbox, only: [:show] do
          router.resources :checks, only: [:create]
        end
      end
    end

    class Check
      include ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::AttributeAssignment

      attr_accessor :public_token
      attr_accessor :access_token
      attr_accessor :item_id

      attr_accessor :furniture

      def public_token=public_token
        @public_token=public_token

        request = Plaid::ItemPublicTokenExchangeRequest.new(public_token: public_token)
        response = furniture.plaid_client.item_public_token_exchange(request)
        self.access_token = response.access_token
        self.item_id = response.item_id

        byebug

        public_token
      end

      attr_accessor :payer_name
      attr_accessor :payer_email

      attr_accessor :amount
      attr_accessor :memo
    end

    def checks
      Check
    end

    def link_token(person)
      response = plaid_client.link_token_create(plaid_link_token_request(person))
      # TODO: error handling
      response.link_token
    end

    # @return [Utilities::Plaid]
    def utility
      placement.space.utility_hookups.where(name: 'Plaid').first&.utility
    end
    delegate :plaid_client, to: :utility

    private

    def plaid_link_token_request(person)
      Plaid::LinkTokenCreateRequest.new(
        {
          user: { client_user_id: person.id },
          client_name: placement.space.name.to_s,
          products: %w[auth identity],
          country_codes: ['US'],
          language: 'en'
        }
      )
    end
  end
end
