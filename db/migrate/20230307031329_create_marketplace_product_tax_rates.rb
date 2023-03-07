class CreateMarketplaceProductTaxRates < ActiveRecord::Migration[7.0]
  def change
    remove_reference :marketplace_products, :tax_rate

    create_table :marketplace_product_tax_rates, id: :uuid do |t|
      t.references :tax_rate, type: :uuid, foreign_key: {to_table: :marketplace_tax_rates}
      t.references :product, type: :uuid, foreign_key: {to_table: :marketplace_products}
      t.timestamps
    end
  end
end
