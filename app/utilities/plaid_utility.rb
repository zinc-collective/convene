# frozen_string_literal: true


# Provides Plaid functionality to a {Space}
# @see https://plaid.com
class PlaidUtility < Utility
  # @return [PlaidUtility::PlaidApi]
  def plaid_client
    @plaid_client ||= sdk::PlaidApi.new(
      sdk::ApiClient.new(plaid_configuration)
    )
  end

  # @see https://plaid.com/docs/api/tokens/#itempublic_tokenexchange
  def exchange_public_token(public_token:)
    request = sdk::ItemPublicTokenExchangeRequest
              .new(public_token: public_token)
    plaid_client.item_public_token_exchange(request)
  end

  # @see https://plaid.com/docs/api/tokens/#linktokencreate
  def create_link_token(person:, space:)
    request = sdk::LinkTokenCreateRequest.new(
      user: { client_user_id: person.id },
      client_name: space.name.to_s,
      products: %w[auth identity],
      country_codes: ['US'],
      language: 'en'
    )
    response = plaid_client
                .link_token_create(request)
    # TODO: error handling
    response.link_token
  end

  def account_number_for(access_token:, item_id:)
    request = sdk::AuthGetRequest.new(access_token: access_token)
    response = plaid_client.auth_get(request)
    response.numbers.ach.find { |a| a.account_id = item_id }.account
  end

  def routing_number_for(access_token:, item_id:)
    request = sdk::AuthGetRequest.new(access_token: access_token)
    response = plaid_client.auth_get(request)
    response.numbers.ach.find { |a| a.account_id = item_id }.account
  end

  def plaid_configuration
    sdk::Configuration.new do |configuration|
      configuration.server_index =
        sdk::Configuration::Environment[environment]
      configuration.api_key['PLAID-CLIENT-ID'] = client_id
      configuration.api_key['PLAID-SECRET'] = secret
      configuration.api_key['Plaid-Version'] = version
    end
  end

  validates_presence_of :client_id
  def client_id
    configuration['client_id']
  end

  def client_id=(client_id)
    configuration['client_id'] = client_id
  end

  validates_presence_of :secret
  def secret
    configuration['secret']
  end

  def secret=(secret)
    configuration['secret'] = secret
  end

  AVAILABLE_ENVIRONMENTS = %w[sandbox development production].freeze
  validates_presence_of :environment
  validates_inclusion_of :environment, in: AVAILABLE_ENVIRONMENTS
  def environment
    configuration['environment']&.downcase&.to_s
  end

  def environment=(environment)
    configuration['environment'] = environment
  end

  validates_presence_of :version
  def version=(version)
    configuration['version'] = version
  end

  def version
    configuration.fetch('version', '2020-09-14')
  end

  def attribute_names
    super + %i[environment secret client_id version]
  end

  # I got sick of having to remember to prefix `Plaid` with `::` when
  # referencing the official library.
  # @returns [::Plaid]
  def sdk
    ::Plaid
  end
end