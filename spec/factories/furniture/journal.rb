FactoryBot.define do
  factory :journal, class: "Journal::Journal" do
    room
    furniture_kind { :journal }
  end

  factory :journal_entry, class: "Journal::Entry" do
    headline { Faker::Fantasy::Tolkien.poem }
    body { (1..5).to_a.sample.times.map { Faker::Movies::Hobbit.quote }.join("\n\n") }
    journal

    trait :published do
      published_at { Time.current - (0..10).to_a.sample.days }
    end

    trait :with_keywords do
      transient do
        count { 3 }
      end

      after(:build) do |entry, evaluator|
        entry.body += "\n\nKeywords: "
        entry.body += evaluator.count.times.map do |_|
          "##{Faker::Fantasy::Tolkien.location.gsub(/['\s-](.)/) { |_| $1.upcase }}"
        end.join(" ")
      end
    end
  end

  factory :journal_keyword, class: "Journal::Keyword" do
    sequence(:canonical_keyword) { |n| "#{Faker::Fantasy::Tolkien.location}-#{n}" }
    journal
  end
end
