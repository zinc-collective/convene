class RemoveThemesFromSpaces < ActiveRecord::Migration[7.0]
  def change
    remove_column :spaces, :theme, :string
  end
end
