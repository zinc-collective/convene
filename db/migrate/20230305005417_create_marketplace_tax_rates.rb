class CreateMarketplaceTaxRates < ActiveRecord::Migration[7.0]
  def change
    create_table :marketplace_tax_rates, id: :uuid do |t|
      t.integer :tax_rate
      t.string :label
      t.references :marketplace, type: :uuid, foreign_key: {to_table: :furniture_placements}
      t.timestamps
    end

    change_table :marketplace_products do |t|
      t.references :tax_rate, type: :uuid, foreign_key: {to_table: :marketplace_tax_rates}
    end
  end
end
