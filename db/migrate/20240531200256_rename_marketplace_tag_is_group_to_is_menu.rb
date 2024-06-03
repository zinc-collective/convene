class RenameMarketplaceTagIsGroupToIsMenu < ActiveRecord::Migration[7.1]
  def change
    safety_assured { rename_column :marketplace_tags, :is_group, :is_menu }
  end
end
