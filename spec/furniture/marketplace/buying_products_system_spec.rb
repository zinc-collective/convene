require "rails_helper"
require "money-rails/helpers/action_view_extension"

# @see https://github.com/zinc-collective/convene/issues/1326
describe "Marketplace: Buying Products", type: :system do
  include MoneyRails::ActionViewExtension
  include Spec::StripeCLI::Helpers

  let(:space) { create(:space, :with_entrance, :with_members) }
  let(:marketplace) { create(:marketplace, :ready_for_shopping, room: space.entrance) }

  around do |ex|
    stripe_listen(forward_to: polymorphic_url(marketplace.location(child: :stripe_events))) do |webhook_signing_secret|
      marketplace.update(stripe_webhook_endpoint_secret: webhook_signing_secret)
      ex.run
    end
  end

  it "Works for Guests" do
    visit(polymorphic_path(marketplace.room.location))
    set_delivery_details(delivery_address: "123 N West St Oakland, CA",
      delivery_area: marketplace.delivery_areas.first,
      contact_phone_number: "1234567890")

    add_product_to_cart(marketplace.products.first)

    expect(page).to have_content("Total: #{humanized_money_with_symbol(marketplace.products.first.price + marketplace.delivery_areas.first.price)}")

    click_link_or_button("Checkout")
    pay(card_number: "4242424242424242", card_expiry: "1240", card_cvc: "123", billing_name: "Ahsoka Tano", email: "AhsokaTano@example.com", billing_postal_code: "12345")

    expect(page).to have_content("Order History", wait: 30)
    expect(page).to have_content("123 N West St Oakland, CA")
  end

  def add_product_to_cart(product)
    within("##{dom_id(product).gsub("product", "cart_product")}") do
      click_link_or_button(t("marketplace.cart_product_component.add"))
    end
  end

  def set_delivery_details(delivery_address:, delivery_area:, contact_phone_number:)
    click_link_or_button("Add delivery details to checkout")
    fill_in("Delivery address", with: delivery_address)
    select(delivery_area.label, from: "Delivery area")
    fill_in("Contact phone number", with: "1234567890")
    fill_in("Contact email", with: "hello@example.com")
    click_link_or_button("Save changes")
  end

  def pay(card_number:, card_expiry:, card_cvc:, billing_name:, email:, billing_postal_code:)
    fill_in("cardNumber", with: card_number)
    fill_in("cardExpiry", with: card_expiry)
    fill_in("cardCvc", with: card_cvc)
    fill_in("billingName", with: billing_name)
    fill_in("email", with: email)
    fill_in("billingPostalCode", with: billing_postal_code)

    find("label[for='enableStripePass']").click
    find("*[data-testid='hosted-payment-submit-button']").click
  end
end
