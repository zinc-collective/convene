class AddRevokedToInvitationStatusEnum < ActiveRecord::Migration[7.0]
  def change
    add_enum_value :invitation_status, "revoked"
  end
end
