require "rails_helper"

# @see https://github.com/zinc-collective/convene/issues/1326
describe "Marketplace: Configuring Square", type: :system do
  let(:space) { create(:space, :with_entrance, :with_members) }
  let(:marketplace) { create(:marketplace, room: space.entrance) }

  before do
    sign_in(space.members.first, space)
    visit(polymorphic_path(marketplace.location(child: :notification_methods)))
  end

  describe "Viewing the page" do
    it "Displays the Square sync section and form" do
      expect(page).to have_content("See new orders directly in your Square Seller dashboard")
      expect(page).to have_content("Add your credentials")
      expect(page).to have_content("See new orders directly in your Square Seller dashboard")
    end
  end

  describe "Activating Square sync" do
    it "Allows adding Square settings" do
      fill_in :marketplace_square_access_token, with: "anything"
      fill_in :marketplace_square_location_id, with: "anything"

      click_button("Save changes")

      expect(page).to have_content("Square notification settings updated succesfully!")
      expect(page).to have_content("Sync is active")
      expect(page).to have_css("details:not([open])")
    end
  end

  describe "Deactivating Square sync" do
    let(:marketplace) { create(:marketplace, :with_square, room: space.entrance) }

    it "Allows deleting Square settings" do
      find("details").click

      fill_in :marketplace_square_access_token, with: ""
      fill_in :marketplace_square_location_id, with: ""
      click_button("Save changes")

      expect(page).to have_content("Square notification settings updated succesfully!")
      expect(page).to have_content("Add your credentials")
      expect(page).to have_css("details[open]")
    end
  end
end
