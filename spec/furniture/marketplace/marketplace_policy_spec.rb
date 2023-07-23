require "rails_helper"

RSpec.describe Marketplace::MarketplacePolicy, type: :policy do
  subject { described_class }

  permissions :index?, :show? do
    it { is_expected.to permit(member, marketplace) }
    it { is_expected.to permit(neighbor, marketplace) }
    it { is_expected.to permit(operator, marketplace) }
    it { is_expected.to permit(guest, marketplace) }
  end

  permissions :new?, :create?, :destroy?, :edit?, :update? do
    it { is_expected.to permit(operator, marketplace) }
    it { is_expected.to permit(member, marketplace) }
    it { is_expected.not_to permit(neighbor, marketplace) }
    it { is_expected.not_to permit(guest, marketplace) }
  end
end
