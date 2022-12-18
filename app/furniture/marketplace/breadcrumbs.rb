# frozen_string_literal: true

# @see https://github.com/kzkn/gretel

crumb :marketplace do |marketplace|
  parent :room, marketplace.room
  link 'Marketplace', marketplace.location
end

crumb :marketplace_checkout do |checkout|
  parent :marketplace, checkout.cart.marketplace
  link 'Checkout', url_for([space, room, checkout])
end

crumb :marketplace_products do |marketplace|
  parent :marketplace, marketplace
  link 'Products', marketplace.location(:products)
end

crumb :marketplace_product do |product|
  parent :marketplace_products, product.marketplace
  link product.name, product.location
end

crumb :new_marketplace_product do |product|
  parent :marketplace_products, product.marketplace
  link 'Add a Product', [:new] + marketplace.location(:product)
end

crumb :edit_marketplace_product do |product|
  parent :marketplace_product, product
  link 'Edit', [:edit] + product.location
end
