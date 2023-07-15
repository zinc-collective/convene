# frozen_string_literal: true

require "rails_helper"

RSpec.describe Journal::Keyword, type: :model do
  it { is_expected.to validate_presence_of(:canonical_keyword) }
  it { is_expected.to validate_uniqueness_of(:canonical_keyword).case_insensitive.scoped_to(:journal_id) }
  it { is_expected.to belong_to(:journal).inverse_of(:keywords) }

  describe ".search" do
    it "returns the `Keywords` that match either canonicaly or via aliases" do
      dog = create(:journal_keyword, canonical_keyword: "Dog", aliases: ["doggo"])
      cat = create(:journal_keyword, canonical_keyword: "Cat", aliases: ["meower"])

      expect(described_class.search("Doggo")).to include(dog)
      expect(described_class.search("Dog")).to include(dog)
      expect(described_class.search("Cat")).to include(cat)
      expect(described_class.search("Meower")).to include(cat)
      expect(described_class.search("Meower", "Dog")).to include(cat)
      expect(described_class.search("Meower", "Dog")).to include(dog)
    end
  end
end
