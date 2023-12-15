require "rails_helper"

# @see https://github.com/zinc-collective/convene/issues/1136
describe "Marketplace: Delivery Areas", type: :system do
  let(:space) { create(:space, :with_entrance, :with_members) }
  let(:marketplace) { create(:marketplace, :ready_for_shopping, room: space.entrance) }

  before do
    sign_in(space.members.first, space)
  end

  describe "Deleting Delivery Areas" do
    context "when the Delivery Area is Discarded" do
      let(:delivery_area) do
        create(:marketplace_delivery_area, :archived, marketplace:,
          label: "Oakland", price_cents: 10_00)
      end

      it "clears the Delivery Area from Carts" do
        cart = create(:marketplace_cart, delivery_area:, marketplace:)
        visit(polymorphic_path(marketplace.location(child: :delivery_areas)))
        click_link("Archived Delivery Areas")
        within("##{dom_id(delivery_area)}") do
          accept_confirm { click_link(I18n.t("destroy.link_to")) }
        end

        expect(page).not_to have_content(delivery_area.label)
        expect(cart.reload.delivery_area).to be_nil
      end

      it "is impossible when there is an Order" do
        delivery_area = create(:marketplace_delivery_area, :archived, marketplace:, label: "Oakland",
          price_cents: 10_00)

        create(:marketplace_order, delivery_area:, marketplace:)
        visit(polymorphic_path(marketplace.location(child: :delivery_areas)))
        click_link("Archived Delivery Areas")

        within("##{dom_id(delivery_area)}") do
          expect(page).not_to have_content(I18n.t("destroy.link_to"))
        end
      end
    end
  end
end
