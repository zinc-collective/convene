# frozen_string_literal: true

class InvitationsController < ApplicationController
  def create
    # TODO: Extract a DeliverInvitationJob that sets the last sent at
    if invitation.save
      SpaceInvitationMailer.space_invitation_email(invitation).deliver_later
      redirect_to edit_space_path(invitation.space),
                  notice: t('.success', invitee_email: invitation.email,
                                        invitee_name: invitation.name)
    else
      redirect_to edit_space_path(invitation.space),
                  alert: t('.failure', invitee_email: invitation.email,
                                       invitee_name: invitation.name)
    end
  end

  def invitation_params
    params.require(:invitation).permit(:name, :email)
          .merge(last_sent_at: Time.zone.now, invitor: current_person)
  end

  def invitation
    @invitation ||= policy_scope(current_space.invitations).new(invitation_params).tap do |invitation|
      authorize(invitation)
    end
  end
end
