require "rails_helper"

# @see https://github.com/zinc-collective/convene/issues/1576
describe "Marketplace: Collecting Payments", type: :system do
  # @see https://github.com/zinc-collective/convene/issues/1622
  describe "via Stripe" do
    let(:space) { create(:space, :with_entrance, :with_members) }

    before do
      sign_in(space.members.first, space)
    end

    it "sets the Distributor's Stripe API Key" do # rubocop:disable RSpec/ExampleLength
      marketplace = create(:marketplace, room: space.entrance)
      visit polymorphic_path(marketplace.room.location)

      within("##{dom_id(marketplace, :onboarding)}") do
        click_on("Manage Marketplace")
      end

      click_on("Payment Settings")
      click_on("View Stripe Account")
      click_on("Add a Stripe API key to #{space.name}")
      click_on("Add Utility")
      select("stripe", from: "Type")
      fill_in("Name", with: "Test Stripe Account")
      click_on("Create")
      click_on("Edit stripe 'Test Stripe Account'")
      fill_in("Api token", with: ENV.fetch("STRIPE_API_KEY", "not-a-real-key"))
      click_on("Save changes to Stripe Utility")

      expect(page).to have_content("Test Stripe Account")
      expect(space.utilities).to exist(utility_slug: "stripe")
      expect(space.utilities.find_by(utility_slug: "stripe").utility.api_token).to eq(ENV.fetch("STRIPE_API_KEY", "not-a-real-key"))

      visit polymorphic_path(marketplace.location(:edit))
      click_on("Payment Settings")
      click_on("View Stripe Account")
      expect(page).to have_content("Connect to Stripe")
    end

    it "connects the Vendor's Stripe Account" do
      marketplace = create(:marketplace, :with_stripe_utility, room: space.entrance)
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
