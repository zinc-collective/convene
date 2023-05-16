class MarketplaceAddBazaarToTaxRate < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!
  def change
    add_reference :marketplace_tax_rates, :bazaar, type: :uuid, null: true, index: {algorithm: :concurrently}
  end
end
