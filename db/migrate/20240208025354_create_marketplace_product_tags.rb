class CreateMarketplaceProductTags < ActiveRecord::Migration[7.1]
  def change
    create_table :marketplace_tags, id: :uuid do |t|
      t.references :bazaar, type: :uuid
      t.string :label

      t.timestamps
    end

    create_table :marketplace_product_tags, id: :uuid do |t|
      t.references :product, type: :uuid, foreign_key: {to_table: :marketplace_products}
      t.references :tag, type: :uuid, foreign_key: {to_table: :marketplace_tags}

      t.timestamps
    end
  end
end
