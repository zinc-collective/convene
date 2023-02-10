class RenameMarketplaceCartsAndDropForeignKeyConstraint < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key "marketplace_carts", "furniture_placements", column: "marketplace_id"

    rename_table :marketplace_carts, :marketplace_orders
  end
end
