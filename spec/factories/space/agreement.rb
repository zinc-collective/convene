FactoryBot.define do
  factory :space_agreement, class: "Space::Agreement" do
    name { Faker::Cannabis.cannabinoid }
    body { "#{Faker::Emotion.adjective} #{Faker::Emotion.noun}" }
  end
end
