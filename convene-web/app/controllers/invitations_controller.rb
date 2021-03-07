class InvitationsController < ApplicationController

  # TODO: fix create action to create invitation data so spec test passes
  def create
    @space_invitation = current_space.invitations.new(invitation_params)
    @space_invitation.save!
    redirect_to [current_space, @space_invitation]
  end

  def invitation_params
    params.require(:invitation).permit(:name, :email)
  end
end