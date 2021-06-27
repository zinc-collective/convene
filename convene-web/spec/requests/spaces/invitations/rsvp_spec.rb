RSpec.describe "/spaces/:space_id/invitations/:invitation_id/rsvp", type: :request do
  describe "GET /spaces/:space_id/invitations/:invitation_id/rsvp" do
    context 'as a guest' do
    end

    context 'as a neighbor' do
    end

    context 'as a space member' do
    end
  end


  describe "PUT /spaces/:space_id/invitations/:invitation_id/rsvp" do
    context 'as a guest' do
      it 'registers them when they accept the invitation' do
        person = Person.find_by(email: invitation.email)

        expect(invitation).to be_accepted
        expect(one_time_password_email).to have_been_delivered
        expect(response).to redirect_to(space_authenticated_session_path(invitation.space))
        expect(person.space_memberships.find_by(space: space)).to be_present
        expect(person.confirmed_at).to be_blank
      end
    end
  end
end