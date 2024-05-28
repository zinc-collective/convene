class AddIsGroupToMarketplaceTag < ActiveRecord::Migration[7.1]
  def change
    add_column :marketplace_tags, :is_group, :boolean, default: false, null: false
  end
end
