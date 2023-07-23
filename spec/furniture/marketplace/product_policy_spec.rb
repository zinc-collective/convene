require "rails_helper"

RSpec.describe Marketplace::ProductPolicy, type: :policy do
  subject { described_class }

  let(:product) { create(:marketplace_product, marketplace: marketplace) }

  describe "#permitted_attributes" do
    subject(:permitted_attributes) { described_class.new(nil, nil).permitted_attributes }

    it { is_expected.to include :price }
  end

  include Spec::Marketplace::CommonLets

  permissions :create?, :destroy?, :edit?, :update? do
    it { is_expected.to permit(member, product) }
    it { is_expected.to permit(operator, product) }

    it { is_expected.not_to permit(neighbor, product) }
    it { is_expected.not_to permit(guest, product) }
  end

  permissions :index?, :show? do
    it { is_expected.to permit(guest, product) }
    it { is_expected.to permit(neighbor, product) }
    it { is_expected.to permit(member, product) }
    it { is_expected.to permit(operator, product) }
  end
end
