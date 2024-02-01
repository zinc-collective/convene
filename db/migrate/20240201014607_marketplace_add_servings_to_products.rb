class MarketplaceAddServingsToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :marketplace_products, :servings, :integer, null: true
  end
end
