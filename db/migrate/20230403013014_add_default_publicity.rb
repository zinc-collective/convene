class AddDefaultPublicity < ActiveRecord::Migration[7.0]
  def up
    change_column :rooms, :publicity_level, :string, default: :listed, null: false
  end

  def down
    change_column :rooms, :publicity_level, :string, default: nil, null: true
  end
end
