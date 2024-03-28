require "rails_helper"

RSpec.describe "Slots" do
  include ActionText::SystemTestHelper

  let(:space) { create(:space, :with_members) }
  let(:section) { create(:room, space:) }

  scenario "Adding a Text Block to a Slot" do
    sign_in(space.members.first, space)
    visit(polymorphic_path(section.location(:edit)))

    click_link("Add Text Block")
    expect(page).to have_current_path(polymorphic_path(section.location(:new, child: :text_block)))

    fill_in_rich_text_area("Body", with: "Prepare yourself for AMAZING")
    click_button("Create")

    expect(section.slots.count).to eq(1)
    expect(section.slots.first.slottable).to be_a(TextBlock)
    expect(sections.slots.first.slottable.body).to eq("Prepare yourself for AMAZING")
  end
end
