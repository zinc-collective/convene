class AddShopperToMarketplaceCarts < ActiveRecord::Migration[7.0]
  def change
    create_table :marketplace_shoppers, id: :uuid  do |t|
      t.references(:person, type: :uuid, foreign_key: {to_table: :people}, index: {unique: true})
      t.timestamps
    end

    change_table :marketplace_carts do |t|
      t.references :shopper, type: :uuid, foreign_key: {to_table: :marketplace_shoppers}
    end
  end
end
