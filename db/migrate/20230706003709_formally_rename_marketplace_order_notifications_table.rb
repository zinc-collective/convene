class FormallyRenameMarketplaceOrderNotificationsTable < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      rename_table :marketplace_order_notification_methods, :marketplace_notification_methods
    end
  end
end
