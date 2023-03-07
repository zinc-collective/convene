class DropRoomsAccessCode < ActiveRecord::Migration[7.0]
  def change
    remove_column :rooms, :access_code, :string
    change_column :rooms, :access_level, :string, default: :public
  end
end
