# frozen_string_literal: true

require "rails_helper"

RSpec.describe Journal::Keyword, type: :model do
  it { is_expected.to validate_presence_of(:canonical_keyword) }
  it { is_expected.to validate_uniqueness_of(:canonical_keyword).case_insensitive.scoped_to(:journal_id) }
  it { is_expected.to belong_to(:journal).inverse_of(:keywords) }

  describe ".by_length" do
    it "orders the results by the length of their canonical keyword" do
      journal = create(:journal)
      create_list(:journal_keyword, 5, journal: journal)
      results = described_class.by_length
      expect(results[0].canonical_keyword.length).to be >= results[1].canonical_keyword.length
      expect(results[1].canonical_keyword.length).to be >= results[2].canonical_keyword.length
      expect(results[2].canonical_keyword.length).to be >= results[3].canonical_keyword.length
      expect(results[3].canonical_keyword.length).to be >= results[4].canonical_keyword.length
    end
  end

  describe ".extract_and_create_from!" do
    it "doesn't skip longer versions" do
      journal = create(:journal)
      journal.keywords.extract_and_create_from!("#SarinsGarden is a large #WorldGarden on the planet #Sarin.")

      expect(described_class).to exist(canonical_keyword: "SarinsGarden", journal: journal)
      expect(described_class).to exist(canonical_keyword: "WorldGarden", journal: journal)
      expect(described_class).to exist(canonical_keyword: "Sarin", journal: journal)
    end
  end

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
