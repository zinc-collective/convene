class CreateMarketplaceDeliveryAreas < ActiveRecord::Migration[7.0]
  def change
    create_table :marketplace_delivery_areas, id: :uuid do |t|
      t.references :marketplace, type: :uuid, foreign_key: {to_table: :furnitures}
      t.string :label
      t.monetize :price
      t.timestamps
    end
  end
end
