require "rails_helper"

RSpec.describe Furniture do
  it { is_expected.to belong_to(:room).inverse_of(:gizmos) }
  it { is_expected.to have_one(:space).through(:room).inverse_of(:gizmos) }

  describe "#furniture" do
    it "returns the configured piece of furniture" do
      furniture = build(:furniture, settings: {content: "# A Block"})

      expect(furniture.furniture).to be_a(MarkdownTextBlock)
      expect(furniture.furniture.content).to eql("# A Block")
    end
  end

  describe "#slot" do
    let(:room) { create(:room) }
    let(:placements) { create_list(:furniture, 3, room: room) }
    # rubocop:disable RSpec/IndexedLet
    let(:placement1) { placements[0] }
    let(:placement2) { placements[1] }
    let(:placement3) { placements[2] }
    # rubocop:enable RSpec/IndexedLet

    before {
      placement1
      placement2
      placement3
    }

    it "inserts new placement between existing slots" do
      new_placement = create(:furniture, room: room, slot_position: 1)
      expect(placement1.slot_rank).to eq(0)
      expect(new_placement.slot_rank).to eq(1)
      expect(placement2.slot_rank).to eq(2)
      expect(placement3.slot_rank).to eq(3)
    end

    it "gets placed last without an explicit position" do
      new_placement = create(:furniture, room: room, slot_position: nil)
      expect(new_placement).to be_valid
      expect(new_placement.slot_position).to eq(:last)
    end
  end

  describe "#setting" do
    class TestFurniture < described_class # rubocop:disable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration
      setting :name, default: "some default value"
    end

    let(:furniture) { TestFurniture.new }

    it "adds a writer for the setting" do
      furniture.name = "fancy name"
      expect(furniture.settings["name"]).to eq("fancy name")
    end

    it "adds a reader for the setting" do
      furniture.settings["name"] = "fancier name"
      expect(furniture.name).to eq("fancier name")
    end

    it "can set a default value" do
      expect(furniture.name).to eq("some default value")
    end
  end

  describe "#secrets" do
    it "starts as an empty hash" do
      expect(build(:furniture).secrets).to eq({})
    end

    it "is encrypted" do
      utility = described_class.new(secrets: {api_key: "asdf"})
      expect(utility.secrets).to eq("api_key" => "asdf")
      expect(utility.secrets_ciphertext).not_to be_empty
    end
  end
end
