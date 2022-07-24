# frozen_string_literal: true

# Provids Vendors a location to sell their products
class Marketplace
  include Placeable

  def self.append_routes(router)
    router.namespace :marketplace do
      router.resources :orders do
        router.resources :items
      end
    end
  end

  def delivery_fee=(delivery_fee)
    settings['delivery_fee'] = delivery_fee
  end

  def delivery_fee
    settings['delivery_fee']
  end

  def order_notification_email=(order_notification_email)
    settings['order_notification_email'] = order_notification_email
  end

  def order_notification_email
    settings['order_notification_email']
  end

  def stripe_account=(stripe_account)
    settings['stripe_account'] = stripe_account
  end

  def stripe_account
    settings['stripe_account']
  end

  def products
    [{ name: "1lb of Bananas", price_cents: 1_39 }, { name: "32oz of Greek Yogurt", price_cents: 7_99 }].map do |product_attributes|
      Marketplace::Product.new(product_attributes)
    end
  end

  def order
    orders.last || Marketplace::Order.create(location:placement)
  end

  def orders
    Marketplace::Order.where(location: placement)
  end

  def attribute_names
    super + %w[delivery_fee order_notification_email stripe_account]
  end
end
