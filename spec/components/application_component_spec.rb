require "rails_helper"

RSpec.describe ApplicationComponent do
  subject(:component) { described_class.new }

  describe "#policy" do
    subject(:policy) { component.policy(resource) }

    before { component.current_person = current_person }

    let(:resource) { build(:space) }
    let(:current_person) { build(:person) }

    it { is_expected.to eq(SpacePolicy.new(current_person, resource)) }
  end
end
