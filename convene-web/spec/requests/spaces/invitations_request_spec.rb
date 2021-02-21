require 'rails_helper'

RSpec.describe "/spaces/:space_id/invitations", type: :request do
  it "doesn't expsose" do
    client = Client.create!
    space = Space.create!(:client => client, :name => "bar")

    post "/spaces/#{space.slug}/invitations", :params => { :invitation => {:name => "foobar", :email => "foobar@example.com"} }
    expect(response).to be_ok
    expect(space.invitations.find_by(name: 'foobar', email: 'foobar@example.com')).to be_present
  end
end
