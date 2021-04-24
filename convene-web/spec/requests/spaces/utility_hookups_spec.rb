# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/spaces/:space_id/utility_hookups' do
  let(:space) { FactoryBot.create(:space, :with_members) }
  let(:utility_hookup_attributes) { FactoryBot.attributes_for(:utility_hookup, :jitsi) }
  describe 'POST /spaces/:space_id/utility_hookups' do
    subject(:perform_request) do
      post "/spaces/#{space.id}/utility_hookups", params: { utility_hookup: utility_hookup_attributes }
    end

    it '404s when someone who is not a space member tries to create a utility hookup' do
      outsider = FactoryBot.create(:person)
      sign_in(outsider)

      expect { perform_request }.not_to(change { space.utility_hookups.count })

      expect(response).to be_not_found
    end

    it 'creates a UtilityHookup on the given space' do
      sign_in(space.members.first)

      expect { perform_request }.to(change { space.utility_hookups.count }.by(1))

      expect(response).to redirect_to space_path(space)
      expect(space.utility_hookups.last.utility_slug).to eql('jitsi')
      expect(space.utility_hookups.last.hookup.configuration.data).to eql(utility_hookup_attributes[:configuration])
    end
  end
end
