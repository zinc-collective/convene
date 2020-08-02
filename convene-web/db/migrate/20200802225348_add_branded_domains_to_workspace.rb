class AddBrandedDomainsToWorkspace < ActiveRecord::Migration[6.0]
  def change
    add_column :workspaces, :branded_domain, :string
  end
end
