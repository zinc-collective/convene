class SupportUuidInPasswordlessSessions < ActiveRecord::Migration[6.0]
  def change
    remove_index :passwordless_sessions, column: [:authenticatable_type, :authenticatable_id] if index_exists? :authenticatable_type, :authenticatable_id
    remove_column :passwordless_sessions, :authenticatable_id
    add_column :passwordless_sessions, :authenticatable_id, :uuid
    add_index :passwordless_sessions, [:authenticatable_type, :authenticatable_id], name: 'authenticatable'
    # change_column :passwordless_sessions, :authenticatable_id, :uuid
  end
end
