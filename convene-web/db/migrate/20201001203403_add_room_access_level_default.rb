class AddRoomAccessLevelDefault < ActiveRecord::Migration[6.0]
  def change
    Room.where(access_level: nil).update_all(access_level: 'unlocked')
    change_column :rooms, :access_level, :string, default: 'unlocked'
    change_column :rooms, :access_level, :string, null: false
  end
end
