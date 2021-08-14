# frozen_string_literal: true

module Utilities
  # Provides Plaid functionality to a {Space}
  # @see https://plaid.com
  class Plaid < Utility
    # @return [Plaid::PlaidApi]
    def plaid_client
      @plaid_client ||= ::Plaid::PlaidApi.new(
        ::Plaid::ApiClient.new(plaid_configuration)
      )
    end

    def plaid_configuration
      ::Plaid::Configuration.new do |configuration|
        configuration.server_index =
          ::Plaid::Configuration::Environment[environment]
        configuration.api_key['PLAID-CLIENT-ID'] = client_id
        configuration.api_key['PLAID-SECRET'] = secret
        configuration.api_key['Plaid-Version'] = version
      end
    end

    def client_id
      configuration['client_id']
    end

    def client_id=(client_id)
      configuration['client_id']=client_id
    end

    def secret
      configuration['secret']
    end

    def secret=(secret)
      configuration['secret']=secret
    end

    def environment
      configuration['environment']&.downcase&.to_s
    end

    def environment=(environment)
      configuration['environment'] = environment
    end

    def version=(version)
      configuration['version'] = version
    end

    def version
      configuration.fetch('version', '2020-09-14')
    end

    def attribute_names
      super + [:environment, :secret, :client_id, :version]
    end
  end

  class PlaidPolicy < Utility::Policy
    def permitted_params
      [:environment, :secret, :client_id, :version]
    end
  end
end
