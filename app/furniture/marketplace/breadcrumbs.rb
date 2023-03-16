# frozen_string_literal: true

# @see https://github.com/kzkn/gretel

crumb :marketplace do |marketplace|
  parent :room, marketplace.room
  link "Marketplace", marketplace.location
end

crumb :edit_marketplace do |marketplace|
  parent :room, marketplace.room
  link t("marketplace.marketplace.edit"), marketplace.location(:edit)
end

crumb :marketplace_checkout do |checkout|
  parent :marketplace, checkout.cart.marketplace
  link "Checkout", checkout.location
end

crumb :marketplace_order do |order|
  parent :marketplace_orders, order.marketplace
  link "Order from #{order.created_at.to_fs(:long_ordinal)}", order.location
end

crumb :marketplace_orders do |marketplace|
  parent :marketplace, marketplace
  link t("marketplace.order.index"), marketplace.location(child: :orders)
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
  parent :marketplace_product, product
  link "Edit", product.location(:edit)
end

crumb :new_tax_rate do |tax_rate|
  parent :edit_marketplace, tax_rate.marketplace
  link "Add a Tax Rate", marketplace.location(:new, child: :tax_rate)
end

crumb :edit_tax_rate do |tax_rate|
  parent :edit_marketplace, tax_rate.marketplace
  link "Edit Tax Rate '#{tax_rate.label}'", marketplace.location(:new, child: :tax_rate)
end
