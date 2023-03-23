class DropMarketplaceOrderContactEmail < ActiveRecord::Migration[7.0]
  def change
    remove_column :marketplace_orders, :contact_email, :string
  end
end
