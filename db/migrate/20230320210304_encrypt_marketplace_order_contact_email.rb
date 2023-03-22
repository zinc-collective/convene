class EncryptMarketplaceOrderContactEmail < ActiveRecord::Migration[7.0]
  def change
    add_column :marketplace_orders, :contact_email_ciphertext, :string
  end
end
