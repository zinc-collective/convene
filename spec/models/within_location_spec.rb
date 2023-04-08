require "rails_helper"

RSpec.describe WithinLocation do
  let(:child) { resource_class.new(parent: parent) }

  let(:resource_class) do
    Class.new do
      include WithinLocation
      attr_accessor :parent
      location(parent: :parent, routed_as: routed_as)

      def initialize(parent:)
        self.parent = parent
      end

      def self.model_name
        ActiveModel::Name.new(self, nil, "Child")
      end
    end
  end

  let(:parent) { parent_class.new }
  let(:parent_class) do
    Class.new do
      include WithinLocation
      def parent_location
        []
      end
    end
  end

  describe "#location(action = :show, child: nil)" do
    subject(:location) { child.location(action) }

    context "when routed_as a :resource" do
      before { resource_class.location(parent: :parent, routed_as: :resource) }

      context "when the action is :new" do
        let(:action) { :new }

        it { is_expected.to eql([:new, parent, :child]) }
      end

      context "when the action is :edit" do
        let(:action) { :edit }

        it { is_expected.to eql([:edit, parent, :child]) }
      end

      context "when routed_as: :resources" do
        before { resource_class.location(parent: :parent, routed_as: :resources) }

        context "when the action is :new" do
          let(:action) { :new }

          it { is_expected.to eql([:new, parent, child]) }
        end

        context "when the action is :edit" do
          let(:action) { :edit }

          it { is_expected.to eql([:edit, parent, child]) }
        end
      end
    end
  end
end
