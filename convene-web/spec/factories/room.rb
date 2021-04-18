FactoryBot.define do
  factory :room do
    space
    name { FFaker::Book.genre }
    publicity_level { 'listed' }
  end
end
