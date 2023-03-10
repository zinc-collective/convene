class AddContactPhoneCiphertextToMarketplaceOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :marketplace_orders, :contact_phone_number_ciphertext, :string
  end
end
