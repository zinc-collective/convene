require "rails_helper"

# @see https://github.com/zinc-collective/convene/issues/1326
describe "Marketplace: Selling Products", type: :system do
  let(:space) { create(:space, :with_entrance, :with_members) }
  let(:marketplace) { create(:marketplace, room: space.entrance) }
  let(:product) { create(:marketplace_product, marketplace:) }
  let(:cart) { create(:marketplace_cart, marketplace:) }
  let(:order) { create(:marketplace_order, marketplace:) }

  before do
    sign_in(space.members.first, space)
  end

  describe "Archiving Products" do
    before do
      cart.cart_products.create(product:, quantity: 1)
      order.ordered_products.create(product:, quantity: 1)
    end

    it "Removes the Product from any Carts" do
      visit(polymorphic_path(marketplace.location(child: :products)))

      expect do
        within("##{dom_id(product)}") do
          click_link(I18n.t("archive.link_to"))
        end
      end.not_to change { marketplace.products.count }

      product.reload
      expect(product).to be_archived
      expect(cart.products).not_to include(product)
      expect(order.products).to include(product)
    end
  end

  describe "Removing Products" do
    let(:product) { create(:marketplace_product, :archived, marketplace:) }

    before do
      cart.cart_products.create(product:, quantity: 1)
    end

    it "Deletes the Product from the Database" do
      visit(polymorphic_path(marketplace.location(child: :products)))
      click_link("Archived Products")

      within("##{dom_id(product)}") do
        accept_confirm { click_link(I18n.t("destroy.link_to")) }
      end

      expect(page).not_to have_content(product.name)
      expect(marketplace.products.reload).to be_empty
      expect(cart.cart_products).not_to exist(product_id: product.id)
    end

    context "when the Product has Orders" do
      before do
        order.ordered_products.create(product:, quantity: 1)
      end

      it "cannot be Removed" do
        visit(polymorphic_path(marketplace.location(child: :products)))
        click_link("Archived Products")

        within("##{dom_id(product)}") do
          expect(page).not_to have_content(I18n.t("destroy.link_to"))
        end
      end
    end
  end
end
