# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/spaces/:space_id/utility_hookups' do
  describe 'POST /spaces/:space_id/utility_hookups' do
    it 'creates a UtilityHookup on the given space' do
      space = FactoryBot.create(:space)
      jitsi_hookup_attributes = FactoryBot.attributes_for(:utility_hookup, :jitsi)

      post "/spaces/#{space.id}/utility_hookups", params: { utility_hookup: jitsi_hookup_attributes }

      expect(response).to redirect_to space_path(space)
      expect(space.utility_hookups.last.utility_slug).to eql('jitsi')
      expect(space.utility_hookups.last.hookup.meet_domain).to eql(jitsi_hookup_attributes[:configuration][:meet_domain])
    end
  end
end
