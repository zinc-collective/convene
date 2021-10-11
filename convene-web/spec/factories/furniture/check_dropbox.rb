FactoryBot.define do
  factory :check_dropbox, class: 'Furniture::CheckDropbox' do
    transient do
      room { build(:room) }
    end

    placement do
      association :furniture_placement, { furniture_kind: 'check_dropbox', room: room }
    end
  end

  factory :check_dropbox_check, class: 'Furniture::CheckDropbox::Check' do
    sequence(:payer_name) { |i| "Payer #{i}"}
    payer_email { "#{payer_name.downcase.gsub(' ','-')}@example.com" }
    amount { 100_00 }
    sequence(:memo) { |i| "Check Memo #{i}" }
    sequence(:public_token) { |i| "Public Token #{i}" }
    association :space
  end
end
