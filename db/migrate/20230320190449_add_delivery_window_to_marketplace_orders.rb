class AddDeliveryWindowToMarketplaceOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :marketplace_orders, :delivery_window, :string
  end
end
