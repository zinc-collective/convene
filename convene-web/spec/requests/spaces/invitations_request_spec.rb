require 'rails_helper'

RSpec.describe "/spaces/:space_id/invitations", type: :request do
  it "created and sends an invitation for a space" do
    client = Client.create!
    space = Space.create!(:client => client, :name => "bar")
    mail = double(deliver_later: true)
    allow(SpaceInvitationMailer).to receive(:space_invitation_email).and_return(mail)

    post "/spaces/#{space.slug}/invitations", :params => { :invitation => {:name => "foobar", :email => "foobar@example.com"} }

    invitation = space.invitations.find_by(name: 'foobar', email: 'foobar@example.com')

    expect(invitation).to be_present
    expect(invitation.status).to eq("pending")

    expect(response).to redirect_to(edit_space_path(space))
    expect(flash[:notice]).to eql(I18n.t('invitations.create.success', invitee_email: invitation.email, invitee_name: invitation.name))

    expect(SpaceInvitationMailer).to have_received(:space_invitation_email)
      .with(invitation)
    expect(mail).to have_received(:deliver_later)
  end
end
