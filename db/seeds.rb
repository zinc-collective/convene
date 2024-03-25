# frozen_string_literal: true

# Emails for test people to use for logging in
OPERATOR_EMAIL = "operator@example.com"
MEMBER_EMAIL = "member@example.com"

Person.find_by(email: OPERATOR_EMAIL) ||
  FactoryBot.create(:person, :operator, name: "Ollie Operator", email: OPERATOR_EMAIL)

space = Space.find_by(name: "Stevie's Space") ||
  FactoryBot.create(:space, :with_members, :with_entrance, name: "Stevie's Space")

space.members.first.update!(name: "Stevie Spacecat", email: MEMBER_EMAIL)

MarkdownTextBlock.find_by(room: space.entrance) ||
  FactoryBot.create(
    :markdown_text_block,
    room: space.entrance,
    content: <<~MARKDOWN
      ### Welcome to Stevie's Space!

      This is the entrance section. And this text is inside a markdown block.

      Cool, huh? 😎

      > #{Faker::Movies::HitchhikersGuideToTheGalaxy.quote}
    MARKDOWN
  )

SectionNavigation::SectionNavigation.find_or_create_by!(room: space.entrance)

marketplace_section = space.rooms.find_by(name: "Magnificent Marketplace") ||
  FactoryBot.create(
    :room, space: space, name: "Magnificent Marketplace",
    description: "A marvelous marketplace for magic merchandise.",
    hero_image: FactoryBot.create(:media)
  )
FactoryBot.create(:marketplace, :full, room: marketplace_section)

journal_section = space.rooms.find_by(name: "Jazzy Journal") ||
  FactoryBot.create(
    :room, space:, name: "Jazzy Journal",
    description: "Here is where I jive and jam in my journal. " \
      "Jump in and join me as I joyfully jot down whatever I'm jazzed about just now.",
    hero_image: FactoryBot.create(:media, :journal)
  )
journal = Journal::Journal.find_by(room: journal_section) ||
  FactoryBot.create(:journal, room: journal_section)

FactoryBot.create_list(:journal_entry, 7, :with_keywords, :published, journal:) if journal.entries.empty?
