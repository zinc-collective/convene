# frozen_string_literal: true

FactoryBot.define do
  factory :person do
    name { Faker::Name.name }
    email { "#{name.downcase.gsub(' ', '-')}@example.com" }
  end
end
