require 'rails_helper'

RSpec.describe "/spaces/:space_id/invitations", type: :request do
  it "created and sends an invitation for a space" do
    client = Client.create!
    space = Space.create!(:client => client, :name => "bar")
    mail = double(deliver_later: true)
    allow(SpaceInvitationMailer).to receive(:space_invitation_email).and_return(mail)

    post "/spaces/#{space.slug}/invitations", :params => { :invitation => {:name => "foobar", :email => "foobar@example.com"} }

    invitation = space.invitations.find_by(name: 'foobar', email: 'foobar@example.com')

    expect(response).to redirect_to([space, invitation])
    expect(invitation).to be_present

    # TODO finish building logic to get below assertions to pass
    # generate mailer and views
    expect(SpaceInvitationMailer).to have_received(:space_invitation_email)
    expect(mail).to have_received(:deliver_later)
    expect(invitation.status).to eq("pending")
  end

  # ------ #
  # NOTES
  # ------ #
  # Kelly H, Zee, Egbet decided these are the possible invitation statuses:
  # pending - email was not sent yet due to mailer issues etc.
  # sent - email was sent but not accepted
  # accepted - receiver accepted the invitation
  # rejected - receivers rejected the invitation

  # FUTURE STATUS AND TEST:
  # expired status and tests for testing the possible scenarios
end
