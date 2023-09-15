require "rails_helper"

# @see https://github.com/zinc-collective/convene/issues/1576
describe "Marketplace: Collecting Payments", type: :system do
  # @see https://github.com/zinc-collective/convene/issues/1622
  describe "via Stripe" do
    it "connects the Vendor's Stripe Account" do
      space = create(:space, :with_entrance, :with_members)
      marketplace = create(:marketplace, :with_stripe_utility, room: space.entrance)
      sign_in(space.members.first, space)

      visit polymorphic_path(marketplace.room.location)

      within("##{dom_id(marketplace, :onboarding)}") do
        click_on("Manage Marketplace")
      end
      click_on("Payment Settings")
      click_on("View Stripe Account")
      expect(page).to have_content("Connect to Stripe")
      # @todo actually figure out how to do the connect to stripe bit :X
    end
  end
end
