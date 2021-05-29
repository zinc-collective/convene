FactoryBot.define do
  factory :authentication_method do
    contact_method { :email }
    sequence(:contact_location) { |n| "method-#{n}@example.com" }
  end
end
