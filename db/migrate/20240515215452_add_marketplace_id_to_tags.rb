class AddMarketplaceIdToTags < ActiveRecord::Migration[7.1]
  def change
    safety_assured { add_reference :marketplace_tags, :marketplace, foreign_key: {to_table: :furnitures}, index: true, type: :uuid }

    # Reassign tags to closest marketplace
    reversible do |dir|
      dir.up do
        Marketplace::Tag.find_each do |tag|
          next if tag.products.empty? && tag.bazaar_id.nil?

          marketplace = tag.products.first&.marketplace || Marketplace::Bazaar.find(tag.bazaar_id).marketplaces.first

          tag.update!(marketplace_id: marketplace.id) if marketplace.present?
        end

        # Fail safe for malformed user data
        Marketplace::Tag.where(marketplace_id: nil).destroy_all
      end

      dir.down do
        Marketplace::Tag.find_each do |tag|
          bazaar = tag.marketplace.bazaar
          tag.update(bazaar_id: bazaar.id)
        end
      end
    end

    safety_assured { change_column_null(:marketplace_tags, :marketplace_id, false) }

    safety_assured { remove_reference :marketplace_tags, :bazaar, index: true, type: :uuid }
  end
end
