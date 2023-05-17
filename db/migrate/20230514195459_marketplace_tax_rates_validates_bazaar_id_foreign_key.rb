class MarketplaceTaxRatesValidatesBazaarIdForeignKey < ActiveRecord::Migration[7.0]
  def change
    validate_foreign_key :marketplace_tax_rates, :spaces, column: :bazaar_id, validate: false
  end
end
