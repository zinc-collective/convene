# frozen_string_literal: true

module Utilities
  # Provides Plaid functionality to a {Space}
  # @see https://plaid.com
  class Plaid < Utility
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
      configuration['environment']
    end

    def environment=(environment)
      configuration['environment']=environment
    end

    def attribute_names
      super + [:environment, :secret, :client_id]
    end
  end

  class PlaidPolicy < Utility::Policy
    def permitted_params
      [:environment, :secret, :client_id]
    end
  end
end
