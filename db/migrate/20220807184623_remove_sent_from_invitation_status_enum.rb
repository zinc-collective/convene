class RemoveSentFromInvitationStatusEnum < ActiveRecord::Migration[7.0]
  def change
    reversible do |direction|
      direction.up do
        execute "UPDATE invitations SET status='pending' WHERE status='sent'"
        # remove_enum_value :invitation_status, 'sent'
      end
      direction.down do
        add_enum_value :invitation_status, "sent"
      end
    end
  end
end
