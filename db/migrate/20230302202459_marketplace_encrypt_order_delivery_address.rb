class MarketplaceEncryptOrderDeliveryAddress < ActiveRecord::Migration[7.0]
  def change
    rename_column :marketplace_orders, :delivery_address, :deprecated_delivery_address
    add_column :marketplace_orders, :delivery_address_ciphertext, :text
  end
end
