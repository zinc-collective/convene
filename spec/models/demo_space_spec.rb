require "rails_helper"

RSpec.describe DemoSpace, type: :model do
  describe ".prepare" do
    context "When the environment is set to enable demo" do
      before { allow(Feature).to receive(:enabled?).with(:demo).and_return(true) }

      it "creates a space suitable for demoing Convene" do
        demo_space = DemoSpace.prepare
        aggregate_failures do
          expect(demo_space).to be_persisted
          expect(demo_space.name).to eql("Convene Demo")
          expect(demo_space.slug).to eql("convene-demo")
          expect(demo_space.branded_domain).to eql("convene-demo.zinc.coop")

          expect(demo_space.rooms.find_by(name: "Zee's Desk")).to be_present
          expect(demo_space.rooms.find_by(name: "Zee's Desk")).to be_listed
          expect(demo_space.rooms.find_by(name: "Vivek's Desk")).to be_present
          expect(demo_space.rooms.find_by(name: "Vivek's Desk")).to be_listed
          expect(demo_space.rooms.find_by(name: "Water Cooler")).to be_present
          expect(demo_space.rooms.find_by(name: "Water Cooler")).to be_listed

          expect(demo_space.rooms.find_by(name: "The Ada Lovelace Room")).to be_present
          expect(demo_space.rooms.find_by(name: "The Ada Lovelace Room")).to be_listed
        end
      end
    end

    context "When the environment is set to disable demo" do
      before { allow(Feature).to receive(:enabled?).with(:demo).and_return(false) }

      it "does not create demo space" do
        expect do
          DemoSpace.prepare
        end.not_to change { [Space.count, Client.count, Room.count] }
      end
    end

    it "is idempotent" do
      DemoSpace.prepare
      expect do
        DemoSpace.prepare
      end.not_to change { [Space.count, Client.count, Room.count] }
    end
  end
end
