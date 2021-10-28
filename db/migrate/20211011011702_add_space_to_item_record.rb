class AddSpaceToItemRecord < ActiveRecord::Migration[6.1]
  def change
    add_reference :item_records, :space, type: :uuid
  end
end
