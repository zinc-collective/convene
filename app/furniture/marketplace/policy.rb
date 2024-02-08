class Marketplace
  class Policy < ApplicationPolicy
    def create?
      return true if current_person.operator?
      return true if current_person.member_of?(space)

      return true if shopper&.person.blank? && !current_person.authenticated?

      return true if shopper&.person == current_person

      false
    end
    alias_method :update?, :create?

    def shopper
      return object if object.is_a?(Shopper)

      object.shopper if object.respond_to?(:shopper)
    end

    def marketplace
      return object if object.is_a?(Marketplace)

      object.marketplace if object.respond_to?(:marketplace)
    end
    delegate :space, to: :marketplace

    module SpecFactories
      def self.included(spec)
        spec.let(:marketplace) { create(:marketplace) }
        spec.let(:membership) { create(:membership, space: marketplace.room.space) }
        spec.let(:member) { membership.member }
        spec.let(:neighbor) { create(:person) }
        spec.let(:operator) { create(:person, operator: true) }
        spec.let(:guest) { Guest.new }
      end
    end
  end
end
