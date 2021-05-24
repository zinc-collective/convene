# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_examples/a_space_member_only_route'

RSpec.describe '/spaces/:space_id/utility_hookups' do
  let(:space) { FactoryBot.create(:space, :with_members) }
  let(:utility_hookup_attributes) do
    FactoryBot.attributes_for(:utility_hookup,
                              :jitsi)
              .merge({ utility_attributes: { 'meet_domain' => 'meet.example.com' } })
  end
  let(:utility_hookup) { FactoryBot.create(:utility_hookup, space: space) }

  let(:guest) { nil }
  let(:neighbor) { FactoryBot.create(:person) }
  let(:space_member) { space.members.first }

  let(:actor) { space_member }

  before { sign_in(space, actor) }

  describe 'GET /spaces/:space_id/utility_hookups' do
    let(:changes) { nil }
    subject(:perform_request) do
      get "/spaces/#{space.id}/utility_hookups"
    end

    it_behaves_like 'a space-member only route'

    it 'lists the Spaces Utility Hookups' do
      FactoryBot.create_list(:utility_hookup, 3, space: space)
      perform_request
      expect(response).to render_template(:index)
      expect(assigns(:utility_hookups)).to eq(space.utility_hookups)
    end
  end

  describe 'GET /spaces/:space_id/utility_hookups/:id/edit' do
    let(:changes) {}
    subject(:perform_request) do
      get "/spaces/#{space.id}/utility_hookups/#{utility_hookup.id}/edit"
      response
    end

    it_behaves_like 'a space-member only route'

    it 'exposes the edit form' do
      perform_request

      expect(response).to render_template(:edit)
      expect(response).to render_template(partial: 'utility_hookups/_form')
      expect(assigns(:utility_hookup)).to eq(utility_hookup)
    end
  end

  describe 'PUT /spaces/:space_id/utility_hookups/:id' do
    subject(:perform_request) do
      put "/spaces/#{space.id}/utility_hookups/#{utility_hookup.id}",
          params: { utility_hookup: utility_hookup_attributes }
      response
    end
    let(:changes) { -> { utility_hookup.reload.attributes } }

    it_behaves_like 'a space-member only route'

    it 'Updates the Utility Hookup' do
      expect { perform_request }.to(change { utility_hookup.reload.attributes })

      expect(response).to redirect_to edit_space_path(space)
      expect(utility_hookup.utility_slug).to eq(utility_hookup_attributes[:utility_slug])
      expect(utility_hookup.utility.configuration).to eq(utility_hookup_attributes[:utility_attributes])
    end
  end

  describe 'POST /spaces/:space_id/utility_hookups' do
    let(:changes) { -> { space.utility_hookups.count } }

    subject(:perform_request) do
      post "/spaces/#{space.id}/utility_hookups", params: { utility_hookup: utility_hookup_attributes }
    end

    it_behaves_like 'a space-member only route'

    it 'Creates a Utility Hookup on the given space' do
      expect { perform_request }.to(change { space.utility_hookups.count }.by(1))

      expect(response).to redirect_to edit_space_path(space)
      expect(space.utility_hookups.last.utility_slug).to eql('jitsi')
      expect(space.utility_hookups.last.utility.configuration).to eq(utility_hookup_attributes[:utility_attributes])
    end
  end
end
