FactoryBot.define do
  factory :journal, class: "Journal::Journal" do
    room
  end

  factory :journal_entry, class: 'Journal::Entry' do
    headline { Faker::Fantasy::Tolkien.poem }
    body { 5.times.map { headline }.join("\n") }
    journal
  end
end
