FactoryBot.define do
  factory :space_agreement, class: "Space::Agreement" do
    space

    name { Faker::Cannabis.cannabinoid }
    body { "#{Faker::Emotion.adjective} #{Faker::Emotion.noun}" }
  end
end
