class AddInvitationReferenceToMembership < ActiveRecord::Migration[7.0]
  def change
    add_reference :space_memberships, :invitation, type: :uuid, index: true, foreign_key: true, null: true
  end
end
