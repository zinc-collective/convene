require "rails_helper"

# @see https://github.com/zinc-collective/convene/issues/1576
describe "Marketplace: Collecting Payments", type: :system do
  # @see https://github.com/zinc-collective/convene/issues/1622
  describe "via Stripe" do
    let(:space) { create(:space, :with_entrance, :with_members) }

    before do
      sign_in(space.members.first, space)
    end

    it "sets the Distributor's Stripe API Key" do
      marketplace = create(:marketplace, room: space.entrance)
      visit polymorphic_path(marketplace.room.location)

      within("##{dom_id(marketplace, :onboarding)}") do
        click_link("Manage Marketplace")
      end

      click_link("Payment Settings")
      within("#stripe_overview") do
        click_link("Add Stripe Account")
      end
      click_link("Add a Stripe API key to #{space.name}")
      click_link("Add Utility")
      select("stripe", from: "utility_utility_slug")
      fill_in("Name", with: "Test Stripe Account")
      click_button("Create")
      click_link("Edit stripe 'Test Stripe Account'")
      fill_in("Api token", with: ENV.fetch("STRIPE_API_KEY", "not-a-real-key"))
      click_button("Save changes to Stripe Utility")

      expect(page).to have_content("Test Stripe Account")
      expect(space.utilities).to exist(utility_slug: "stripe")
      expect(space.utilities.find_by(utility_slug: "stripe").utility.api_token).to eq(ENV.fetch("STRIPE_API_KEY", "not-a-real-key"))

      visit polymorphic_path(marketplace.location(:edit))
      click_link("Payment Settings")
      click_link("View Stripe Account")
      expect(page).to have_content("Connect to Stripe")
    end

    it "connects the Vendor's Stripe Account" do
      marketplace = create(:marketplace, :with_stripe_utility, room: space.entrance)
      visit polymorphic_path(marketplace.room.location)

      within("##{dom_id(marketplace, :onboarding)}") do
        click_link("Manage Marketplace")
      end
      click_link("Payment Settings")
      click_link("View Stripe Account")
      expect(page).to have_content("Connect to Stripe")
      # @todo actually figure out how to do the connect to stripe bit :X
    end
  end
end
