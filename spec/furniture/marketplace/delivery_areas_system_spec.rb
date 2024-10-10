require "rails_helper"

# @see https://github.com/zinc-collective/convene/issues/1136
describe "Marketplace: Delivery Areas", type: :system do
  let(:space) { create(:space, :with_entrance, :with_members) }
  let(:marketplace) { create(:marketplace, :ready_for_shopping, room: space.entrance) }

  before do
    sign_in(space.members.first, space)
  end

  describe "Setting a Delivery Fee" do
    it "allows Percentage-Based Delivery Fees" do
      visit(polymorphic_path(marketplace.location(child: :delivery_areas)))
      click_link("Add Delivery Area")
      fill_in("Label", with: "Percentage Based Delivery Area")
      fill_in("Fee as percentage", with: "10")

      expect { click_button("Create") }.to change(marketplace.delivery_areas, :count).by(1)
      expect(page).to have_content("Percentage Based Delivery Area")
      within(marketplace.delivery_areas.order(created_at: :desc).first) do
        expect(page).to have_content("10% of subtotal")
      end
    end
  end

  describe "Restoring Delivery Areas" do
    let!(:delivery_area) do
      create(:marketplace_delivery_area, :archived, marketplace:,
        label: "Oakland", price_cents: 10_00)
    end

    it "Makes the DeliveryArea selectable" do
      visit(polymorphic_path(marketplace.location(child: :delivery_areas)))
      click_link("Archived Delivery Areas")
      within("##{dom_id(delivery_area)}") do
        click_link("Edit")
      end

      click_button(I18n.t("restore.link_to"))

      expect(page).to have_content(delivery_area.label)
      expect(delivery_area.reload).not_to be_archived
    end
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

        expect(page).to have_no_content(delivery_area.label)
        expect(cart.reload.delivery_area).to be_nil
      end

      it "is impossible when there is an Order" do
        delivery_area = create(:marketplace_delivery_area, :archived, marketplace:, label: "Oakland",
          price_cents: 10_00)

        create(:marketplace_order, delivery_area:, marketplace:)
        visit(polymorphic_path(marketplace.location(child: :delivery_areas)))
        click_link("Archived Delivery Areas")

        within("##{dom_id(delivery_area)}") do
          expect(page).to have_no_content(I18n.t("destroy.link_to"))
        end
      end
    end
  end

  def within(model, *, **, &block)
    page.within("##{dom_id(model)}", *, **, &block)
  end
end
