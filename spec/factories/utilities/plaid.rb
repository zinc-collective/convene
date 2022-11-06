# frozen_string_literal: true

FactoryBot.define do
  factory :plaid_utility_hookup, parent: :utility_hookup do
    utility_slug { "plaid" }
    configuration do
      {
        # Use sandbox client id and secret if they are available, to
        # make it possible to record VCR cassettes in tests.
        "client_id" => ENV.fetch("PLAID_CLIENT_ID", "a-fake-client-id"),
        "secret" => ENV.fetch("PLAID_SECRET", "a-fake-secret"),
        "environment" => "sandbox"
      }
    end
  end
end
