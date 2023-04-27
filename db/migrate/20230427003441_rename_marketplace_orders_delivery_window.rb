class RenameMarketplaceOrdersDeliveryWindow < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      rename_column :marketplace_orders, :delivery_window, :delivery_notes
    end
  end
end
