class CreateMarketplaceEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :marketplace_events, id: :uuid do |t|
      t.references :regarding, polymorphic: true, type: :uuid
      t.text :description

      t.timestamps
    end
  end
end
