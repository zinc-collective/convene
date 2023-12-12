class MarketplaceAddDiscardedAtToDeliveryAreas < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_column :marketplace_delivery_areas, :discarded_at, :datetime
    add_index :marketplace_delivery_areas, :discarded_at, algorithm: :concurrently
  end
end
