# frozen_string_literal: true

module Furniture
  # Renders some HTML in a {Room}.
  class CheckDropbox
    include Placeable

    def link_token(person)
      response = client.link_token_create(plaid_link_token_request(person))
      # TODO: error handling
      response.link_token
    end

    private

    def utility_configuration
      placement.space.utility_hookups.where(name: 'Plaid').first.configuration.with_indifferent_access
    end

    def client
      @client ||= Plaid::PlaidApi.new(Plaid::ApiClient.new(plaid_configuration))
    end

    def plaid_configuration
      Plaid::Configuration.new do |configuration|
        configuration.server_index = Plaid::Configuration::Environment[plaid_environment]
        configuration.api_key['PLAID-CLIENT-ID'] = plaid_client_id
        configuration.api_key['PLAID-SECRET'] = plaid_secret
        configuration.api_key['Plaid-Version'] = plaid_version
      end
    end

    def plaid_environment
      utility_configuration[:environment].downcase.to_s
    end

    def plaid_client_id
      utility_configuration[:client_id]
    end

    def plaid_secret
      utility_configuration[:secret]
    end

    def plaid_version
      utility_configuration[:version] || '2020-09-14'
    end

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
