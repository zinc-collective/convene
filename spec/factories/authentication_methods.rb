# frozen_string_literal: true

FactoryBot.define do
  factory :authentication_method do
    association :person

    contact_method { :email }
    contact_location { person.email }
    last_one_time_password_at { Time.zone.now }
  end
end
