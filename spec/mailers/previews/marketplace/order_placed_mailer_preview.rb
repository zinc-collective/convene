# Preview at http://localhost:3000/rails/mailers/marketplace/order_received_mailer

class Marketplace
  class OrderPlacedMailerPreview < ActionMailer::Preview
    def notification
      OrderPlacedMailer.notification(order)
    end

    private def order
      marketplace = FactoryBot.build(:marketplace, delivery_fee_cents: (10_00..25_00).to_a.sample,
        notify_emails: "distributor@example.com,vendor@example.com")

      tax_rate = FactoryBot.build(:marketplace_tax_rate, marketplace: marketplace)
      order = FactoryBot.build(:marketplace_order, :with_products, marketplace: marketplace,
        delivery_window: 1.hour.from_now, placed_at: 5.minutes.ago,
        product_count: (1..5).to_a.sample, delivery_address: Faker::Address.full_address,
        contact_email: Faker::Internet.safe_email, contact_phone_number: Faker::PhoneNumber.cell_phone)

      order.ordered_products.first.product.tax_rates << tax_rate
      order
    end
  end
end
