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

      # @return [ItemRecord]
      attr_accessor :item_record
      delegate :data, to: :item_record

      def public_token=public_token
        @public_token=public_token

        request = Plaid::ItemPublicTokenExchangeRequest.new(public_token: public_token)
        response = furniture.plaid_client.item_public_token_exchange(request)
        self.access_token = response.access_token
        self.plaid_item_id = response.item_id


        public_token
      end

      def plaid_item_id=(plaid_item_id)
        data['plaid_item_id'] = plaid_item_id
      end

      def plaid_item_id
        data['plaid_item_id']
      end

      def payer_name=(payer_name)
        data['payer_name'] = payer_name
      end

      def payer_name
        data['payer_name']
      end

      def payer_email=(payer_email)
        data['payer_email'] = payer_email
      end

      def payer_email
        data['payer_email']
      end

      def amount=(amount)
        data['amount'] = amount
      end

      def amount
        data['amount']
      end

      def memo=(memo)
        data['memo'] = memo
      end

      def memo
        data['memo']
      end
    end

    def checks
      placement.item_records.of_type(Check)
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
