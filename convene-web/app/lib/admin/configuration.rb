module Admin
  # Configuration values for the admin panel.
  class Configuration
    # The source of truth for configuration data
    # @return [#fetch] (ENV)
    attr_accessor :provider

    # @param provider [#fetch] (ENV)
    def initialize(provider = ENV)
      self.provider = provider
    end

    # See https://api.rubyonrails.org/classes/ActionController/HttpAuthentication/Basic.html
    def basic_auth
      { name: username, password: password }
    end

    private def username
      provider.fetch('ADMIN_USERNAME')
    end

    private def password
      provider.fetch('ADMIN_PASSWORD')
    end

    # Exposes access to confiuration when included.
    module Configurable
      def self.included(composer)
        composer.extend(ClassMethods)
      end

      def configuration
        self.class.configuration
      end

      # Exposes access to confiuration at the class-level.
      module ClassMethods
        def configuration
          @configuration ||= Configuration.new
        end
      end
    end
  end
end
