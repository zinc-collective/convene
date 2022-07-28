class AddInvitationStatusEnum < ActiveRecord::Migration[7.0]
  # Copied from Invitation.status enum on 7/6/2022
  STATUSES = {
    pending: "pending",
    sent: "sent",
    accepted: "accepted",
    rejected: "rejected",
    expired: "expired",
    ignored: "ignored"
  }

  def change
    create_enum :invitation_status, STATUSES.values

    remove_column :invitations, :status, :string

    add_column :invitations, :status, :invitation_status, null: false, default: "pending"
  end
end
