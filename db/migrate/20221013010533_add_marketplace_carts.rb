class AddMarketplaceCarts < ActiveRecord::Migration[7.0]
  def change
    create_table :marketplace_carts, id: :uuid do |t|
      t.references :marketplace, type: :uuid, foreign_key: {to_table: :furniture_placements}
      t.timestamps
    end

    # We can't change the primary key type so we drop and recreate :'(
    drop_table :marketplace_products do |t|
      t.references :marketplace, type: :uuid, foreign_key: {to_table: :furniture_placements}
      t.string :name
      t.string :description
      t.monetize :price
      t.timestamps
    end

    create_table :marketplace_products, id: :uuid do |t|
      t.references :marketplace, type: :uuid, foreign_key: {to_table: :furniture_placements}
      t.string :name
      t.string :description
      t.monetize :price
      t.timestamps
    end

    create_table :marketplace_cart_products, id: :uuid do |t|
      t.belongs_to(:cart, foreign_key: {to_table: :marketplace_carts}, type: :uuid)
      t.belongs_to(:product, foreign_key: {to_table: :marketplace_products}, type: :uuid)
      t.integer :quantity
      t.timestamps
    end
  end
end
