class CreateMarketplaceCheckouts < ActiveRecord::Migration[7.0]
  def change
    create_table :marketplace_checkouts, id: :uuid do |t|
      t.belongs_to :cart, type: :uuid
      t.belongs_to :shopper, type: :uuid
      t.timestamps
    end
  end
end
