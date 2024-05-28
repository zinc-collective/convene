# frozen_string_literal: true

# Emails for test people to use for logging in
OPERATOR_EMAIL = "operator@example.com"
MEMBER_EMAIL = "member@example.com"

raise "Your database contains data. Run `rails db:seed:replant` to truncate and re-seed it." if Space.exists?

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

    > #{Faker::Movies::HitchhikersGuideToTheGalaxy.quote}
  MARKDOWN
)

SectionNavigation::SectionNavigation.create!(space:, room: space.entrance)

marketplace_section = FactoryBot.create(
  :room, space: space, name: "Magnificent Marketplace",
  description: "A marvelous marketplace for magic merchandise.",
  hero_image: FactoryBot.create(:media)
)
marketplace = FactoryBot.create(:marketplace, :ready_for_shopping, product_quantity: 16, room: marketplace_section)
magic_menu_group = FactoryBot.create(:marketplace_tag, :group, marketplace: marketplace, label: "Magic")
fire_tag = FactoryBot.create(:marketplace_tag, marketplace: marketplace, label: "🔥")
marketplace.products.sample(8).each do |product|
  product.tags << magic_menu_group
end
marketplace.products.sample(8).each do |product|
  product.tags << fire_tag
end

journal_section = FactoryBot.create(
  :room, space:, name: "Jazzy Journal",
  description: "Here is where I jive and jam in my journal. " \
    "Jump in and join me as I joyfully jot down whatever I'm jazzed about just now.",
  hero_image: FactoryBot.create(:media, :journal)
)
journal = FactoryBot.create(:journal, room: journal_section)
FactoryBot.create_list(:journal_entry, 7, :with_keywords, :published, journal:)

_content_block_section = FactoryBot.create(:room, space:, name: "Content Block-o-Clock",
  description: "Content Blocks show static Words, Photos, or Videos!")

# FactoryBot.create(:content_block, in_section: content_block_section)
