class MarketplaceAddNoteToCartProduct < ActiveRecord::Migration[7.1]
  def change
    add_column :marketplace_cart_products, :note, :string, null: false, default: ""
  end
end
