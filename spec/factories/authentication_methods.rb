# frozen_string_literal: true

FactoryBot.define do
  factory :authentication_method do
    association :person

    contact_method { :email }
    contact_location { person.email }
  end
end
