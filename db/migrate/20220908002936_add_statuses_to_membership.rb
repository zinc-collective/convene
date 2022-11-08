class AddStatusesToMembership < ActiveRecord::Migration[7.0]
  STATUSES = {
    active: "active",
    revoked: "revoked"
  }.freeze

  def change
    create_enum :membership_status, STATUSES.values

    add_column :memberships, :status, :membership_status, null: false, default: "active"
  end
end
