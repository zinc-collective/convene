require "rails_helper"
require "money-rails/helpers/action_view_extension"

# @see https://github.com/zinc-collective/convene/issues/1326
describe "Marketplace: Buying Products", type: :system do
  include MoneyRails::ActionViewExtension
  include ActiveJob::TestHelper
  include Spec::StripeCLI::Helpers

  let(:space) { create(:space, :with_entrance, :with_members) }
  let(:marketplace) { create(:marketplace, :ready_for_shopping, :with_square, room: space.entrance) }

  around do |ex|
    visit root_path

    stripe_listen(events: ["checkout.session.completed"], forward_to: polymorphic_url(marketplace.location(child: :stripe_events), **url_options)) do |webhook_signing_secret|
      marketplace.update(stripe_webhook_endpoint_secret: webhook_signing_secret)
      ex.run
    end
  end

  def url_options
    server_uri = URI(page.server_url)
    {host: server_uri.host, port: server_uri.port}
  end

  context "when there is not a DeliveryArea selected" do
    it "Prevents Checkout unless a DeliveryArea is selected" do
      create(:marketplace_delivery_area, marketplace: marketplace)

      visit(polymorphic_path(marketplace.room.location))

      add_product_to_cart(marketplace.products.first)

      expect { click_link("Checkout") }.to raise_error(Capybara::ElementNotFound)
    end
  end

  describe "when changing DeliveryArea" do
    it "updates the Delivery Fee" do
      create(:marketplace_delivery_area,
        marketplace: marketplace, label: "Oakland", price_cents: 10_00)

      visit(polymorphic_path(marketplace.location))

      select("Oakland", from: :cart_delivery_area_id)
      click_button("Save")

      expect(page).to have_content("Delivery Fee: $10.00")
    end
  end

  describe "when the `Marketplace` has one active `DeliveryArea`" do
    it "allows Checkout" do
      archived_delivery_area = create(:marketplace_delivery_area,
        marketplace: marketplace, label: "Oakland", price_cents: 10_00)
      archived_delivery_area.archive
      visit(polymorphic_path(marketplace.room.location))

      add_product_to_cart(marketplace.products.first)

      expect { click_link("Checkout") }.not_to raise_error
    end
  end

  it "Doesn't offer archived Products for sale" do
    archived_product = create(:marketplace_product, :archived, marketplace:)

    visit(polymorphic_path(marketplace.room.location))

    expect(page).to have_no_content(archived_product.name)
  end

  it "Works for Guests" do # rubocop:disable RSpec/ExampleLength
    visit(polymorphic_path(marketplace.room.location))

    add_product_to_cart(marketplace.products.first)

    expect(page).to have_content("Total: #{humanized_money_with_symbol(marketplace.products.first.price + marketplace.delivery_areas.first.price)}")

    click_link("Checkout")
    expect(page).to have_current_path(polymorphic_path(marketplace.carts.first.location(child: :checkout)))

    set_delivery_details(delivery_address: "123 N West St Oakland, CA",
      contact_email: "AhsokaTano@example.com",
      contact_phone_number: "1234567890")

    expect(page).to have_current_path(polymorphic_path(marketplace.carts.first.location(child: :checkout)))

    pay(card_number: "4000000000000077", card_expiry: "1240", card_cvc: "123", billing_name: "Ahsoka Tano", email: "AhsokaTano@example.com", billing_postal_code: "12345")

    expect(page).to have_content("Order History", wait: 30)
    expect(page).to have_content("123 N West St Oakland, CA")

    perform_enqueued_jobs

    order_received_notifications = ActionMailer::Base.deliveries.select do |mail|
      mail.to.include?(marketplace.notification_methods.first.contact_location)
    end

    expect(order_received_notifications).to be_present
    expect(order_received_notifications.length).to eq 1
    order_placed_notifications = ActionMailer::Base.deliveries.select do |mail|
      mail.to.include?("AhsokaTano@example.com")
    end

    expect(order_placed_notifications).to be_present
    expect(order_placed_notifications.length).to eq 1
  end

  def add_product_to_cart(product)
    within("##{dom_id(product)}") do
      click_button("Add to Cart")
    end
  end

  def set_delivery_details(delivery_address:, contact_phone_number:, contact_email:)
    fill_in("Delivery address", with: delivery_address)
    fill_in("Contact phone number", with: contact_phone_number)
    fill_in("Contact email", with: contact_email)
    click_button("Save")
  end

  def pay(card_number:, card_expiry:, card_cvc:, billing_name:, email:, billing_postal_code:)
    click_button("Place Order")
    fill_in("cardNumber", with: card_number)
    fill_in("cardExpiry", with: card_expiry)
    fill_in("cardCvc", with: card_cvc)
    fill_in("billingName", with: billing_name)
    fill_in("email", with: email)
    fill_in("billingPostalCode", with: billing_postal_code)
    uncheck("enableStripePass", visible: false)
    find("*[data-testid='hosted-payment-submit-button']").click
  end
end
