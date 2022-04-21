# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/spaces/', type: :request do
  include ActiveJob::TestHelper

  describe 'DELETE /spaces/:space_slug/' do
    context 'as an Operator using the API' do
      it "deletes the space and all it's other bits" do
        SystemTestSpace.prepare

        space = Space.find_by(slug: 'system-test')
        delete space_path(space),
               headers: authorization_headers,
               as: :json

        perform_enqueued_jobs

        expect(space.rooms).to be_empty
        expect(space.utility_hookups).to be_empty
        expect(space.items).to be_empty
        expect(space.invitations).to be_empty
        expect(space.space_memberships).to be_empty
      end
    end
  end

  describe 'POST /spaces/' do
    context 'as an Operator using the API' do
      it 'creates a space' do
        name = "System Test #{SecureRandom.hex(4)}"
        post spaces_path,
             params: { space: { name: name, client_attributes: { name: name } } },
             headers: authorization_headers(ENV['OPERATOR_API_KEY']),
             as: :json

        space = Space.find_by(name: name)
        expect(space.rooms).to be_empty
        expect(space.space_memberships).to be_empty
        expect(space.utility_hookups).to be_empty
      end

      it 'creates the space from the given blueprint' do
        name = "System Test #{SecureRandom.hex(4)}"
        post spaces_path,
             params: { space: { name: name, blueprint: :system_test, client_attributes: { name: name } } },
             headers: authorization_headers(ENV['OPERATOR_API_KEY']),
             as: :json

        space = Space.find_by(name: name)
        expect(space.rooms).not_to be_empty
        expect(space.space_memberships).not_to be_empty
        expect(space.utility_hookups).not_to be_empty
      end
    end
  end

  describe 'PUT /space/:space_slug' do
    context 'as a Space Member' do
      let(:space) { create(:space, :with_members, theme: 'purple_mountains') }

      before do
        sign_in_as_member(space)
      end

      it 'updates the theme' do
        put space_path(space), params: { space: { theme: 'desert_dunes' } }

        expect(space.reload.theme).to eq('desert_dunes')
        expect(flash[:notice]).to include('successfully updated')
      end

      it 'shows an error message with an invalid theme' do
        put space_path(space), params: { space: { theme: 'bogus_theme' } }

        expect(space.reload.theme).to eq('purple_mountains')
        expect(flash[:alert]).to include('went wrong')
      end
    end
  end
end
