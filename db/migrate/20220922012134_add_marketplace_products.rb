class AddMarketplaceProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :marketplace_products do |t|
      t.references :space, type: :uuid, foreign_key: true
      t.string :name
      t.string :description
      t.monetize :price
      t.timestamps
    end
  end
end
