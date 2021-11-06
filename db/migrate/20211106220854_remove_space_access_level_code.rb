class RemoveSpaceAccessLevelCode < ActiveRecord::Migration[6.1]
  def change
    remove_column :spaces, :access_level, :string
    remove_column :spaces, :access_code, :string
  end
end
