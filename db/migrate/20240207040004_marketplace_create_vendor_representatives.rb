class MarketplaceCreateVendorRepresentatives < ActiveRecord::Migration[7.1]
  def change
    create_table :marketplace_vendor_representatives, id: :uuid do |t|
      t.references :marketplace, type: :uuid, foreign_key: {to_table: :furnitures}
      t.references :person, type: :uuid, foreign_key: true, null: true

      t.string :email_address
      t.timestamps
    end
  end
end
