# frozen_string_literal: true

FactoryBot.define do
  factory :plaid_utility_hookup, parent: :utility_hookup do
    utility_slug { 'plaid' }
    configuration do
      {
        'client_id' => 'a-fake-client-id',
        'secret' => 'a-fake-secret',
        'environment' => 'sandbox'
      }
    end
  end
end
