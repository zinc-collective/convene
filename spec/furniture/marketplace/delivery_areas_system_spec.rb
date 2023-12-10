require "rails_helper"

# @see https://github.com/zinc-collective/convene/issues/1136
describe "Marketplace: Delivery Areas", type: :system do
  let(:space) { create(:space, :with_entrance, :with_members) }
  let(:marketplace) { create(:marketplace, :ready_for_shopping, room: space.entrance) }

  before do
    sign_in(space.members.first, space)
  end

  describe "Deleting Delivery Areas" do
    it "clears the Delivery Area from Carts" do
      delivery_area = create(:marketplace_delivery_area, marketplace:, label: "Oakland",
        price_cents: 10_00)
      cart = create(:marketplace_cart, delivery_area:, marketplace:)
      visit(polymorphic_path(marketplace.location(child: :delivery_areas)))

      within("##{dom_id(delivery_area)}") do
        accept_confirm { click_link("Remove") }
      end

      expect(page).not_to have_content(delivery_area.label)
      expect(cart.reload.delivery_area).to be_nil
    end

    it "is impossible when there is an Order" do
      delivery_area = create(:marketplace_delivery_area, marketplace:, label: "Oakland",
        price_cents: 10_00)

      create(:marketplace_order, delivery_area:, marketplace:)
      visit(polymorphic_path(marketplace.location(child: :delivery_areas)))

      within("##{dom_id(delivery_area)}") do
        expect(page).not_to have_content("Remove")
      end
    end
  end
end
