class AddPlacedAtToMarketplaceOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :marketplace_orders, :placed_at, :datetime
  end
end
