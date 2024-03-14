require "rails_helper"

RSpec.describe "Slots" do
  let(:space) { create(:space, :with_members) }
  let(:section) { create(:room, space:) }

  scenario "Adding a Text Block to a Slot" do
    sign_in(space.members.first, space)
    visit(polymorphic_path(section.location(:edit)))

    click_link("Add a Slottable")

    select("Text Block", from: "Type")

    click_button("Create Slottable")

    expect(section.slots.count).to eq(1)
    expect(section.slots.slottable).to be_a(TextBlock)
    expect(page).to have_current_path(polymorphic_path(section.slots.slottable))
  end
end
