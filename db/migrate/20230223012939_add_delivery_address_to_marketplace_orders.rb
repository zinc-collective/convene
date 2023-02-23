class AddDeliveryAddressToMarketplaceOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :marketplace_orders, :delivery_address, :string
  end
end
