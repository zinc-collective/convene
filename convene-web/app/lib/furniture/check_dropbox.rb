# frozen_string_literal: true

module Furniture
  # Allows a Space to receive eChecks
  # @see features/furniture/check-drop-off.feature
  class CheckDropbox
    include Placeable

    def link_token(person)
      response = api_client.link_token_create(plaid_link_token_request(person))
      # TODO: error handling
      response.link_token
    end

    def utility
      placement.space.utility_hookups.where(name: 'Plaid').first&.utility
    end
    delegate :api_client, to: :utility

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
