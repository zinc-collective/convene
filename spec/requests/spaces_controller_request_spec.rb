# frozen_string_literal: true

require "rails_helper"

RSpec.describe SpacesController do
  include ActiveJob::TestHelper
  describe "#show" do
    subject(:perform_request) do
      get url
      test_response
    end

    let(:space) { create(:space) }
    let(:url) { polymorphic_url(space) }

    it { is_expected.to be_ok }
    specify { perform_request && assert_select("##{dom_id(space)}") }

    context "with a branded domain" do
      let(:space) { create(:space, branded_domain: "beta.example.com") }

      context "when accessing via the neighborhood url" do
        it { is_expected.to redirect_to "http://beta.example.com" }
      end

      context "when accessing via domain" do
        before do
          space
          host! "beta.example.com"
        end

        let(:url) { "http://beta.example.com" }

        it { is_expected.to be_ok }
        specify { perform_request && assert_select("##{dom_id(space)}") }
      end
    end

    context "when a request is http" do
      let(:space) { create(:space, enforce_ssl: true) }

      it "redirect to https" do
        expect(perform_request).to redirect_to polymorphic_url(space, protocol: "https")
      end
    end
  end

  describe "#destroy" do
    context "when an an Operator using the AP" do
      it "deletes the space and all it's other bits" do
        space = create(:space)

        delete polymorphic_path(space),
          headers: authorization_headers,
          as: :json

        perform_enqueued_jobs

        expect(space.rooms).to be_empty
        expect(space.utilities).to be_empty
        expect(space.invitations).to be_empty
        expect(space.memberships).to be_empty
      end
    end
  end

  describe "#update" do
    context "when a Space Member" do
      let(:space) { create(:space, :with_members, :with_rooms) }

      before do
        sign_in_as_member(space)
      end

      it "updates the Space" do
        new_entrance = space.rooms.sample
        put polymorphic_path(space), params: {space: {entrance_id: new_entrance.id, enforce_ssl: true, branded_domain: "zeespencer.com"}}

        space.reload

        expect(space.entrance).to eql(new_entrance)
        expect(space.enforce_ssl).to be true
        expect(space.branded_domain).to eql("zeespencer.com")
        expect(response).to redirect_to("http://zeespencer.com/edit")
        expect(flash[:notice]).to include("successfully updated")
      end
    end
  end

  describe "#new" do
    subject(:result) do
      sign_in(nil, user)
      get polymorphic_path([:new, :space])
      response
    end

    context "when not logged in" do
      let(:user) { nil }

      it { is_expected.to be_not_found }
    end

    context "when an Operator" do
      let(:user) { create(:person, operator: true) }

      it { is_expected.to be_ok }
    end
  end
end
