require 'rails_helper'

RSpec.describe "/spaces/:space_id/invitations", type: :request do
  it "created and sends an invitation for a space" do
    client = Client.create!
    space = Space.create!(:client => client, :name => "bar")
    mail = double(deliver_now: true)
    allow(SpaceInvitationMailer).to receive(:space_invitation_email).and_return(mail)

    post "/spaces/#{space.slug}/invitations", :params => { :invitation => {:name => "foobar", :email => "foobar@example.com"} }

    invitation = space.invitations.find_by(name: 'foobar', email: 'foobar@example.com')

    expect(response).to redirect_to([space, invitation])
    expect(invitation).to be_present

    # TODO finish building logic to get below assertions to pass
    # generate mailer and views
    expect(SpaceInvitationMailer).to have_received(:space_invitation_email).with(invitation)
    expect(mail).to have_received(:deliver_now)
    expect(invitation.status).to eq("sent")
  end


  # We decided that possible invitation status:
  # pending - email was not sent yet
  # sent - email was sent but not accepted
  # accepted - reciever accepted it
  # rejected - reciever rejected the invitation
  # FUTURE: expired -
  #
  # ALL CREATE INVITATION SCENARIOS  - POST CALL
  # invitation email is sent
  #
  # send invitation to same email if old one expired
end
