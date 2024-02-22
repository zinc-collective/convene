require "rails_helper"

# @see https://github.com/zinc-collective/convene/issues/1326
describe "Marketplace: Selling Products", type: :system do
  include ActionText::SystemTestHelper

  let(:space) { create(:space, :with_entrance, :with_members) }
  let(:marketplace) { create(:marketplace, room: space.entrance) }
  let(:product) { create(:marketplace_product, marketplace:) }
  let(:cart) { create(:marketplace_cart, marketplace:) }
  let(:order) { create(:marketplace_order, marketplace:) }

  before do
    sign_in(space.members.first, space)
  end

  # @see https://github.com/zinc-collective/convene/issues/2168
  describe "Listing Products for Sale" do
    it "Adds the Product to the Menu" do # rubocop:disable RSpec/ExampleLength
      visit(polymorphic_path(marketplace.location(child: :products)))
      click_link("Add a Product")

      fill_in("Name", with: "A Delicious Apple")

      description = <<~DESC.gsub("\n", "")
        A red Apple, grown in the an Orchard
        Made with a Trunk.
      DESC

      fill_in_rich_text_area("Description", with: description)
      fill_in("Price", with: "10.00")
      fill_in("Servings", with: 4)

      expect { click_button("Create") }.to change(marketplace.products, :count).by(1)

      created_product = marketplace.products.last

      visit(polymorphic_path(marketplace.room.location))

      within("##{dom_id(created_product)}") do
        expect(page).to have_content("A Delicious Apple")
        expect(page).to have_content(description)
        expect(page).to have_content("$10.00")
        expect(page).to have_content("Serves 4")
      end
    end
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

  describe "Restoring Products" do
    let!(:product) { create(:marketplace_product, :archived, marketplace:) }

    it "Allows the Product to be added to Carts again" do
      visit(polymorphic_path(marketplace.location(child: :products)))
      click_link("Archived Products")
      within("##{dom_id(product)}") do
        click_link(I18n.t("edit.link_to"))
      end

      click_button(I18n.t("restore.link_to"))
      expect(page).to have_content(product.name)
      expect(product.reload).not_to be_archived
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

      expect(page).to have_no_content(product.name)
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
          expect(page).to have_no_content(I18n.t("destroy.link_to"))
        end
      end
    end
  end
end
