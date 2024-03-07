require "rails_helper"

# @see https://github.com/zinc-collective/convene/issues/2044
describe "Marketplace: Vendor Representatives", type: :system do
  let(:space) { create(:space, :with_entrance, :with_members) }
  let(:marketplace) { create(:marketplace, :ready_for_shopping, room: space.entrance) }

  before do
    sign_in(space.members.first, space)
  end

  describe "Adding a Vendor Representative" do
    it "Requires a Member confirm the Vendor" do
      visit(polymorphic_path(marketplace.location(child: :vendor_representatives)))
      click_link("Add a Representative")
      fill_in("Email address", with: "milton@swingline.example.com")
      expect do
        click_button("Create")
        expect(page).to have_content("Added Representative 'milton@swingline.example.com'")
        marketplace.reload
      end.to change(marketplace.vendor_representatives, :count).by(1)
      representative_milton = marketplace.vendor_representatives.find_by(email_address: "milton@swingline.example.com")

      within("##{dom_id(representative_milton)}") do
        expect(page).to have_content("🛌")
      end
      expect(representative_milton).not_to be_claimable
      expect(representative_milton).not_to be_claimed
      milton = create(:authentication_method, contact_location: "milton@swingline.example.com").person

      expect(representative_milton).to be_claimable
      visit(polymorphic_path(marketplace.location(child: :vendor_representatives)))

      expect do
        within("##{dom_id(representative_milton)}") do
          click_button("👍")
          representative_milton.reload
        end
      end.to change(representative_milton, :claimed?).to(true)

      expect(representative_milton.person).to eq(milton)
    end
  end
end
