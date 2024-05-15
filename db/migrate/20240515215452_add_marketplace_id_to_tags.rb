class AddMarketplaceIdToTags < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_reference :marketplace_tags, :marketplace, index: {unique: true, algorithm: :concurrently}
  end
end
