class AddPositionToMarketplaceTag < ActiveRecord::Migration[7.1]
  def change
    add_column :marketplace_tags, :position, :integer, null: false, default: 0

    Marketplace::Tag.order(:updated_at).each.with_index(1) do |tag, index|
      tag.update_column :position, index # rubocop:disable Rails/SkipsModelValidations
    end
  end
end
