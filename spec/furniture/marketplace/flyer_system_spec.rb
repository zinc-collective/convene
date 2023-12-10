require "rails_helper"

describe "Marketplace: Flyer", type: :system do
  let(:space) { create(:space, :with_entrance, :with_members) }
  let(:marketplace) { create(:marketplace, :ready_for_shopping, room: space.entrance) }

  it "is navigable from the Markeplace edit page" do
    sign_in(space.members.first, space)

    visit(polymorphic_path(marketplace.location(:edit)))

    click_link("Flyer")

    expect(page).to have_content("Delivered by #{space.name}")
    expect(page).to have_content(polymorphic_path(marketplace.room.location))
  end
end
