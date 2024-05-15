class RemoveBazaarIdFromTags < ActiveRecord::Migration[7.1]
  def change
    safety_assured { remove_reference :marketplace_tags, :bazaar, index: true }
  end
end
