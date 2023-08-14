class MarketplaceAddStripeTransferIdToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :marketplace_orders, :stripe_transfer_id, :string
  end
end
