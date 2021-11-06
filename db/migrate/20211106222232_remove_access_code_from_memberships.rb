class RemoveAccessCodeFromMemberships < ActiveRecord::Migration[6.1]
  def change
    remove_column :space_memberships, :access_code, :string
  end
end
