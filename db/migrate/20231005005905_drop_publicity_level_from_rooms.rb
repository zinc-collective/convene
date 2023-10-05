class DropPublicityLevelFromRooms < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      remove_column :rooms, :publicity_level, type: :string, default: :listed
    end
  end
end
