require "rails_helper"

RSpec.describe Space::Agreement do
  subject(:agreement) { build(:space_agreement) }

  it { is_expected.to belong_to(:space).inverse_of(:agreements) }
  it { is_expected.to validate_presence_of :body }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:space_id) }
  it { is_expected.to validate_uniqueness_of(:slug).scoped_to(:space_id) }

  describe ".friendly" do
    subject(:friendly) do
      agreement_a
      described_class.friendly
    end

    let(:agreement_a) { create(:space_agreement, name: "Agreement A") }

    specify { expect(friendly.find("agreement-a")).to eql(agreement_a) }
  end
end
