class InvitationsController < ApplicationController

  # TODO: fix create action to create invitation data so spec test passes
  def create
    @space_invitation = current_space.invitations.new(invitation_params)
    if @space_invitation.save!
      SpaceInvitationMailer.space_invitation_email(@person).deliver_later
      redirect_to [current_space, @space_invitation]
    else
      render :json => "An error has occurred", status: 500
    end
  end

  def invitation_params
    params.require(:invitation).permit(:name, :email)
  end
end