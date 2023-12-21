# frozen_string_literal: true

# Emails for test people to use for logging in
OPERATOR_EMAIL = "operator@example.com"
MEMBER_EMAIL = "member@example.com"

FactoryBot.create(:person, :operator, name: "Ollie Operator", email: OPERATOR_EMAIL)

space = FactoryBot.create(:space, :with_members, :with_entrance, name: "Stevie's Space")
space.members.first.update!(name: "Stevie Spacecat", email: MEMBER_EMAIL)

FactoryBot.create(
  :markdown_text_block,
  room: space.entrance,
  content: <<~MARKDOWN
    ### Welcome to Stevie's Space!

    This is the entrance section. And this text is inside a markdown block.

    Cool, huh? 😎

    #{Faker::Quote.famous_last_words}
  MARKDOWN
)

SectionNavigation::SectionNavigation.create!(space:, room: space.entrance)

marketplace_section = FactoryBot.create(:room, space: space, name: "Magnificent Marketplace")
FactoryBot.create(
  :marketplace,
  :with_products,
  :with_stripe_account,
  :with_stripe_utility,
  :with_delivery_areas,
  :with_notification_methods,
  :with_orders,
  :with_tax_rates,
  room: marketplace_section
)

journal_section = FactoryBot.create(:room, space:, name: "Jazzy Journal")
journal = FactoryBot.create(:journal, room: journal_section)
FactoryBot.create_list(:journal_entry, 3, journal:)
FactoryBot.create_list(:journal_keyword, 2, journal:)
