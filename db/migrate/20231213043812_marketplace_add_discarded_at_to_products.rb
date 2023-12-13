class MarketplaceAddDiscardedAtToProducts < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_column :marketplace_products, :discarded_at, :datetime
    add_index :marketplace_products, :discarded_at, algorithm: :concurrently
  end
end
