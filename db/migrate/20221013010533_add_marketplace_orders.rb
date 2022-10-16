class AddMarketplaceOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :marketplace_orders, id: :uuid do |t|
      t.references :marketplace, type: :uuid, foreign_key: {to_table: :furniture_placements}
      t.timestamps
    end

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

    create_table :marketplace_ordered_products, id: :uuid do |t|
      t.belongs_to(:order, foreign_key: {to_table: :marketplace_orders}, type: :uuid)
      t.belongs_to(:product, foreign_key: {to_table: :marketplace_products}, type: :uuid)
      t.timestamps
    end
  end
end
