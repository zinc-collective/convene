# frozen_string_literal: true

FactoryBot.define do
  factory :authentication_method do
    contact_method { :email }
    contact_location { person.email }

    association :person
  end
end
