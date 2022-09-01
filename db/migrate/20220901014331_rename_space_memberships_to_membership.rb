class RenameSpaceMembershipsToMembership < ActiveRecord::Migration[7.0]
  def change
    rename_table :space_memberships, :memberships
  end
end
