module Spec
  module Marketplace
    # Provides commonly used `let` statements to marketplace specs
    module CommonLets
      def self.included(spec)
        spec.let(:marketplace) { create(:marketplace) }
        spec.let(:space) { marketplace.space }
        spec.let(:room) { marketplace.room }
        spec.let(:membership) { create(:membership, space: marketplace.room.space) }
        spec.let(:member) { membership.member.becomes(::Marketplace::Person) }
        spec.let(:neighbor) { create(:marketplace_person) }
        spec.let(:operator) { create(:marketplace_person, operator: true) }
        spec.let(:guest) { ::Marketplace::Guest.new(session: {}) }
      end
    end
  end
end
