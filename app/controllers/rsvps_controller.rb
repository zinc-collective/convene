class RsvpsController < ApplicationController
  def show
  end

  def update
    rsvp.update(rsvp_params)
    redirect_to new_space_authenticated_session_path(invitation.space, authenticated_session: { contact_method: :email, contact_location: invitation.email })
  end

  def rsvp_params
    params.require(:rsvp).permit(:status)
  end

  helper_method def rsvp
    @rsvp ||= Rsvp.new(invitation: invitation)
  end

  helper_method def invitation
    @invitation ||= Invitation.find(params[:invitation_id])
  end
end