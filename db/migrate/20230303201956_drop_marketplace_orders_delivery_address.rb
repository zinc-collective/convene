class DropMarketplaceOrdersDeliveryAddress < ActiveRecord::Migration[7.0]
  def change
    remove_column :marketplace_orders, :delivery_address, :string
  end
end
