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
  parent :marketplace, order.marketplace
  link "Order from #{order.created_at.to_fs(:long_ordinal)}", order.location
end

crumb :marketplace_products do |marketplace|
  parent :edit_marketplace, marketplace
  link t("marketplace.product.index"), marketplace.location(child: :products)
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
