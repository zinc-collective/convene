FactoryBot.define do
  factory :marketplace_person, class: "Marketplace::Person" do
    name { Faker::Name.name }
    email { "#{name.downcase.tr(" ", "-")}@marketplace.example.com" }
  end
end
