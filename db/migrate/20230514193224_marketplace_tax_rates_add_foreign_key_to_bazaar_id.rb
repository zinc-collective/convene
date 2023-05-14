class MarketplaceTaxRatesAddForeignKeyToBazaarId < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :marketplace_tax_rates, :spaces, column: :bazaar_id, validate: false
  end
end
