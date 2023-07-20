FactoryBot.define do
  factory :journal, class: "Journal::Journal" do
    room
    furniture_kind { :journal }
  end

  factory :journal_entry, class: "Journal::Entry" do
    headline { Faker::Fantasy::Tolkien.poem }
    body { 5.times.map { headline }.join("\n") }
    journal
  end

  factory :journal_keyword, class: "Journal::Keyword" do
    canonical_keyword { Faker::Fantasy::Tolkien.location }
    journal
  end
end
