require 'rails_helper'

RSpec.describe Furniture::CheckDropbox::CheckPolicy, type: :policy do
  let(:subject) { described_class }
  let(:space) { FactoryBot.build_stubbed(:space) }
  let(:check) { instance_double(Furniture::CheckDropbox::Check, space: space) }
  context 'as a guest' do
    let(:actor) { Guest.new }
    permissions :show?, :update?, :edit?, :destroy?, :index? do
      it { is_expected.not_to permit(actor, check) }
    end

    permissions :create? do
      it { is_expected.to permit(actor, check) }
    end
  end

  context 'as a neighbor' do
    let(:actor) do
      FactoryBot.build_stubbed(:person).tap do |actor|
        allow(actor).to receive(:member_of?).with(space).and_return(false)
      end
    end

    permissions :show?, :update?, :edit?, :destroy?, :index? do
      it { is_expected.not_to permit(actor, check) }
    end

    permissions :create? do
      it { is_expected.to permit(actor, check) }
    end
  end

  context 'as a resident' do
    let(:actor) do
      FactoryBot.build_stubbed(:person).tap do |actor|
        allow(actor).to receive(:member_of?).with(space).and_return(true)
      end
    end

    permissions :create?, :index?, :show?, :update?, :edit?, :destroy? do
      it { is_expected.to permit(actor, check) }
    end
  end
end
