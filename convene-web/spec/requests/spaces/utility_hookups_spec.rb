# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/spaces/:space_id/utility_hookups' do
  let(:space) { FactoryBot.create(:space, :with_members) }
  let(:utility_hookup_attributes) { FactoryBot.attributes_for(:utility_hookup, :jitsi) }

  let(:guest) { nil }
  let(:neighbor) { FactoryBot.create(:person) }
  let(:space_member) { space.members.first }

  before { sign_in(actor) }
  describe 'PUT /spaces/:space_id/utility_hookups/:id' do
    let(:utility_hookup) { FactoryBot.create(:utility_hookup, space: space) }
    subject(:perform_request) do
      put "/spaces/#{space.id}/utility_hookups/#{utility_hookup.id}",
          params: { utility_hookup: utility_hookup_attributes }
      response
    end

    context 'As a Guest' do
      let(:actor) { guest }

      it 'is a noop 404' do
        expect { perform_request }.not_to(change { utility_hookup.reload.attributes })
        expect(response).to be_not_found
      end
    end

    context 'As a Neighbor' do
      let(:actor) { neighbor }
      it 'is a no-op 404' do
        expect { perform_request }.not_to(change { utility_hookup.reload.attributes })

        expect(response).to be_not_found
      end
    end

    context 'As a Space Member' do
      let(:actor) { space_member }
      it 'Updates the Utility Hookup' do
        expect { perform_request }.to(change { utility_hookup.reload.attributes })

        expect(response).to redirect_to space_path(space)
        expect(utility_hookup.utility_slug).to eql('jitsi')
        expect(utility_hookup.hookup.configuration.data).to eql(utility_hookup_attributes[:configuration])
      end
    end
  end

  describe 'POST /spaces/:space_id/utility_hookups' do
    subject(:perform_request) do
      post "/spaces/#{space.id}/utility_hookups", params: { utility_hookup: utility_hookup_attributes }
    end
    context 'as a Guest' do
      let(:actor) { nil }
      it 'is a no-op 404' do
        expect { perform_request }.not_to(change { space.utility_hookups.count })

        expect(response).to be_not_found
      end
    end

    context 'As a Neighbor' do
      let(:actor) { neighbor }
      it 'is a no-op 404' do
        expect { perform_request }.not_to(change { space.utility_hookups.count })

        expect(response).to be_not_found
      end
    end

    context 'As a Space Member' do
      let(:actor) { space_member }
      it 'Creates a Utility Hookup on the given space' do
        expect { perform_request }.to(change { space.utility_hookups.count }.by(1))

        expect(response).to redirect_to space_path(space)
        expect(space.utility_hookups.last.utility_slug).to eql('jitsi')
        expect(space.utility_hookups.last.hookup.configuration.data).to eql(utility_hookup_attributes[:configuration])
      end
    end
  end
end
