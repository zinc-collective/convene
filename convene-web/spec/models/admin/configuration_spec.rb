require 'spec_helper'

require 'admin/configuration'

include Admin
RSpec.describe Configuration do
  describe "#basic_auth" do
    it "is a hash suitable for Rails' built in http authentication" do
      configuration = Configuration.new({ "ADMIN_USERNAME" => "admin", "ADMIN_PASSWORD" => "admin" })
      expect(configuration.basic_auth).to include name: "admin", password: "admin"
    end

    it "requires the provider to provide an ADMIN_USERNAME" do
      configuration = Configuration.new({ "ADMIN_PASSWORD" => "admin" })
      expect { configuration.basic_auth }.to raise_error(KeyError, /ADMIN_USERNAME/)
    end

    it "requires the provider to provide an ADMIN_PASSWORD" do
      configuration = Configuration.new({ "ADMIN_USERNAME" => "admin" })
      expect { configuration.basic_auth }.to raise_error(KeyError, /ADMIN_PASSWORD/)
    end
  end

  describe Configuration::Configurable do
    let(:example_consumer) do
      Class.new do
        include Configuration::Configurable
      end
    end
    it "exposes a configuration instance as an instance method" do
      expect(example_consumer.new.configuration).to be_a Configuration
    end
    it "exposes a configuration instance as an class method" do
      expect(example_consumer.configuration).to be_a Configuration
    end
  end
end
