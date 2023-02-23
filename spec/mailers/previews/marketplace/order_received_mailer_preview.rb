# Preview at http://localhost:3000/rails/mailers/marketplace/order_received_mailer

class Marketplace::OrderReceivedMailerPreview < ActionMailer::Preview
  def order_with_products
    marketplace = FactoryBot.build(:marketplace, delivery_fee_cents: (10_00..25_00).to_a.sample)
    order = FactoryBot.build(:marketplace_order, :with_products, marketplace: marketplace,
      product_count: (1..5).to_a.sample, delivery_address: Faker::Address.full_address,
      contact_email: Faker::Internet.safe_email)
    order.marketplace.notify_emails = "distributor@example.com,vendor@example.com"

    Marketplace::OrderReceivedMailer.notification(order)
  end
end
