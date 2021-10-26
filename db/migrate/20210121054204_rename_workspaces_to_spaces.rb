class RenameWorkspacesToSpaces < ActiveRecord::Migration[6.0]
  def change
    rename_column :rooms, :workspace_id, :space_id

    rename_column :workspace_memberships, :workspace_id, :space_id
    rename_table :workspace_memberships, :space_memberships

    rename_table :workspaces, :spaces
  end
end
