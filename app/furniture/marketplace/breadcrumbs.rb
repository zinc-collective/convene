# frozen_string_literal: true

# @see https://github.com/kzkn/gretel

crumb :marketplace do |marketplace|
  parent :room, marketplace.room
  link "Marketplace", marketplace.location
end

crumb :edit_marketplace do |marketplace|
  parent :room, marketplace.room
  link t("marketplace.marketplace.edit.link_to"), marketplace.location(:edit)
end

crumb :marketplace_cart_delivery_area do |cart|
  parent :room, cart.room
  link t("marketplace.cart.delivery_areas.show.link_to"), cart.location(child: :delivery_area)
end

crumb :edit_marketplace_cart_delivery_area do |cart|
  parent :room, cart.room
  link t("marketplace.cart.delivery_areas.edit.link_to"), cart.location(:edit, child: :delivery_area)
end

crumb :marketplace_checkout do |checkout|
  parent :marketplace, checkout.cart.marketplace
  link "Checkout", checkout.location
end

crumb :marketplace_order do |order|
  parent :marketplace_orders, order.marketplace
  link "Order from #{l(order.created_at, format: :long_ordinal)}", order.location
end

crumb :marketplace_orders do |marketplace|
  parent :marketplace, marketplace
  link t("marketplace.orders.index.link_to"), marketplace.location(child: :orders)
end

crumb :marketplace_notification_methods do |marketplace|
  parent :edit_marketplace, marketplace
  link t("marketplace.notification_methods.index.link_to"), marketplace.location(child: :notification_methods)
end

crumb :new_marketplace_notification_method do |notification_method|
  parent :marketplace_notification_methods, notification_method.marketplace
  link t("marketplace.notification_methods.new.link_to"),
    notification_method.marketplace.location(child: :notification_methods)
end

crumb :edit_marketplace_notification_method do |notification_method|
  parent :marketplace_notification_methods, notification_method.marketplace
  link t("marketplace.notification_methods.edit.link_to", contact_location: notification_method.contact_location)
  notification_method.marketplace.location(child: :notification_methods)
end

crumb :marketplace_products do |marketplace|
  parent :edit_marketplace, marketplace
  link t("marketplace.products.index.link_to"), marketplace.location(child: :products)
end

crumb :marketplace_product do |product|
  parent :marketplace_products, product.marketplace
  link product.name, product.location
end

crumb :new_marketplace_product do |product|
  parent :marketplace_products, product.marketplace
  link "Add a Product", marketplace.location(:new, child: :product)
end

crumb :edit_marketplace_product do |product|
  parent :marketplace_products, product.marketplace
  link t("marketplace.products.edit.link_to", name: product.name), product.location(:edit)
end

crumb :marketplace_vendor_representatives do |marketplace|
  parent :edit_marketplace, marketplace
  link t("marketplace.vendor_representatives.index.link_to"), marketplace.location(child: :vendor_representatives)
end

crumb :new_marketplace_vendor_representative do |vendor_representative|
  parent :edit_marketplace, vendor_representative.marketplace
  link t("marketplace.vendor_representatives.new.link_to"), marketplace.location(:new, child: :vendor_representative)
end

crumb :marketplace_delivery_areas do |marketplace|
  parent :edit_marketplace, marketplace
  link t("marketplace.delivery_areas.index.link_to"), marketplace.location(child: :delivery_areas)
end

crumb :new_delivery_area do |delivery_area|
  parent :marketplace_delivery_areas, delivery_area.marketplace
  link "Add a Delivery Area", marketplace.location(:new, child: :delivery_area)
end

crumb :edit_delivery_area do |delivery_area|
  parent :marketplace_delivery_areas, delivery_area.marketplace
  link t("marketplace.delivery_areas.edit.link_to", name: delivery_area.label), marketplace.location(:edit, child: :delivery_area)
end

crumb :show_marketplace_stripe_account do |marketplace|
  parent :edit_marketplace, marketplace
  link t("marketplace.stripe_accounts.show.link_to"), marketplace.location(child: :stripe_account)
end

crumb :marketplace_tags do |marketplace|
  parent :edit_marketplace, marketplace
  link(t("marketplace.tags.index.link_to"), marketplace.location(child: :tags))
end

crumb :new_marketplace_tag do |tag|
  parent :marketplace_tags, tag.marketplace
  link t("marketplace.tags.new.link_to"), marketplace.location(:new, child: :tag)
end

crumb :marketplace_tax_rates do |marketplace|
  parent :edit_marketplace, marketplace
  link t("marketplace.tax_rates.index.link_to"), marketplace.location(child: :tax_rates)
end

crumb :new_tax_rate do |tax_rate|
  parent :marketplace_tax_rates, tax_rate.marketplace
  link "Add a Tax Rate", marketplace.location(:new, child: :tax_rate)
end

crumb :edit_tax_rate do |tax_rate|
  parent :marketplace_tax_rates, tax_rate.marketplace
  link "Edit Tax Rate '#{tax_rate.label}'", marketplace.location(:new, child: :tax_rate)
end

crumb :payment_settings do |marketplace|
  parent :edit_marketplace, marketplace
  link "Manage Payment Settings", marketplace.location(:index, child: :payment_settings)
end
