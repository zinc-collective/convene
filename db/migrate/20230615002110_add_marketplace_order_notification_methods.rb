class AddMarketplaceOrderNotificationMethods < ActiveRecord::Migration[7.0]
  def change
    create_table :marketplace_order_notification_methods, id: :uuid do |t|
      t.references :marketplace, type: :uuid, foreign_key: {to_table: :furnitures}
      t.string :contact_method, default: :email, null: false
      t.string :contact_location_ciphertext, null: false
      t.timestamps
    end
  end
end
