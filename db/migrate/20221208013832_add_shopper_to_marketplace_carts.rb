class AddShopperToMarketplaceCarts < ActiveRecord::Migration[7.0]
  def change
    change_table :marketplace_carts do |t|
      t.references :shopper, type: :uuid, foreign_key: {to_table: :people}
    end
  end
end
