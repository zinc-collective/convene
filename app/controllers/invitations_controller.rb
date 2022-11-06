# frozen_string_literal: true

class InvitationsController < ApplicationController
  def index
  end

  def create
    if invitation.save
      SpaceInvitationMailer.space_invitation_email(invitation).deliver_later
      redirect_to [invitation.space, :invitations],
        notice: t(".success", invitee_email: invitation.email,
          invitee_name: invitation.name)
    else
      flash.now[:alert] = t(".failure", invitee_email: invitation.email,
        invitee_name: invitation.name)
      render :index
    end
  end

  def destroy
    invitation.update!(status: :revoked)
    redirect_to [invitation.space, :invitations],
      notice: t(".success", invitee_email: invitation.email,
        invitee_name: invitation.name)
  end

  def invitation_params
    params.require(:invitation).permit(:name, :email)
      .merge(last_sent_at: Time.zone.now, invitor: current_person)
  end

  helper_method def invitation
    @invitation ||= if params[:id]
      authorize(invitations.find(params[:id]))
    elsif params[:invitation]
      authorize(invitations.new(invitation_params))
    else
      authorize(invitations.new)
    end
  end

  helper_method def space
    current_space
  end

  helper_method def invitations
    policy_scope(current_space.invitations)
  end
end
