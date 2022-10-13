FactoryBot.define do
  factory :journal do
    transient do
      room { build(:room) }
    end

    placement do
      association :furniture_placement, { furniture_kind: 'journal', room: room }
    end
  end

  factory :journal_entry, class: 'Journal::Entry' do
    headline { Faker::Fantasy::Tolkien.poem }
    body { 5.times.map { headline }.join("\n") }
    room factory: :journal_room
  end

  factory :journal_room, class: 'Journal::Room', parent: :room do
    space
  end
end
