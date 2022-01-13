FactoryBot.define do
  factory :check_dropbox, class: 'CheckDropbox' do
    transient do
      room { build(:room) }
    end

    placement do
      association :furniture_placement, { furniture_kind: 'check_dropbox', room: room }
    end
  end

  factory :check_dropbox_check, class: 'CheckDropbox::Check' do
    sequence(:payer_name) { |i| "Payer #{i}" }
    payer_email { "#{payer_name.downcase.gsub(' ', '-')}@example.com" }
    amount { 100_00 }
    sequence(:memo) { |i| "Check Memo #{i}" }
    sequence(:public_token) { |i| "Public Token #{i}" }
    association :space

    trait :sort_of_real do
      public_token { "public-sandbox-14ee4677-e0ad-4ec0-8323-051af5ebfc67" }
      account_description { "Chase - Plaid Checking: XXXX0000" }
      plaid_account_id { "WdBoBqdrzDtjQ8dmv36afqyNdWMPjEtlvKbbA" }
    end
  end
end
