# frozen_string_literal: true

require "rails_helper"

RSpec.describe Space::Factory do
  describe ".create" do
    it "creates a Space from the given attributes" do
      attributes = attributes_for(:space)
      space = described_class.create(attributes)

      expect(space).to be_persisted
      expect(space.name).to eq(attributes[:name])
      expect(space.slug).to be_present
    end

    # @todo this is probably dangerous?
    it "upserts if a Space has the provided name already" do
      existing_space = create(:space)

      attributes = attributes_for(:space,
        name: existing_space.name)
      space = described_class.create(attributes)

      expect(space).to eql(existing_space)
    end

    it "applies the blueprint if it's provided" do
      space = described_class.create(attributes_for(:space,
        blueprint: :system_test))

      expect(space.rooms).to be_present
    end
  end
end
