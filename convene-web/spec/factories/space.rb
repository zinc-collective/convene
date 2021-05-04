FactoryBot.define do
  factory :space do
    client
    name { FFaker::CheesyLingo.title }
  end
end
