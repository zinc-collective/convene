class AddEnforceSslToSpaces < ActiveRecord::Migration[7.0]
  def change
    add_column :spaces, :enforce_ssl, :boolean, default: false, null: false
  end
end
