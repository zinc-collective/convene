require "rails_helper"

RSpec.describe Journal::Entry, type: :model do
  subject(:entry) { build(:journal_entry) }

  it { is_expected.to validate_presence_of(:headline) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to strip_attributes(:slug, :body, :headline) }
  it { is_expected.to belong_to(:journal).inverse_of(:entries) }
  it { is_expected.to have_one(:room).through(:journal) }
  it { is_expected.to have_one(:space).through(:journal) }

  describe "#migrate_to(journal:, keywords: [])" do
    it "appends the given keywords to body and swaps the different journal" do
      entry = create(:journal_entry)
      destination_journal = create(:journal)

      entry.migrate_to(journal: destination_journal, keywords: ["Cooking", "Recipes"])
      expect(entry.journal).to eql(destination_journal)
      expect(entry.keywords).to include(destination_journal.keywords.find_by(canonical_keyword: "Recipes"))
      expect(entry.keywords).to include(destination_journal.keywords.find_by(canonical_keyword: "Cooking"))
    end
  end

  describe "#summary" do
    it { is_expected.to validate_length_of(:summary).is_at_most(300).allow_blank }
  end

  describe "#save" do
    let(:entry) { create(:journal_entry, body: "#GoodTimes") }
    let(:journal) { entry.journal }

    context "when the body is changing" do
      it "idempotently creates `Keywords` in the `Journal` and `Entry`" do
        bad_apple = entry.journal.keywords.create!(canonical_keyword: "BadApple", aliases: ["BadApples"])
        good_times = entry.journal.keywords.find_by!(canonical_keyword: "GoodTimes")
        expect do
          entry.update!(body: "#GoodTimes #HardCider #BadApple #BadApples")
        end.not_to change { "#{bad_apple.reload.updated_at} - #{good_times.reload.updated_at}" }

        expect(journal.keywords.where(canonical_keyword: "GoodTimes")).to exist
        expect(journal.keywords.where(canonical_keyword: "HardCider")).to exist
        expect(journal.keywords.where(canonical_keyword: "BadApples")).not_to exist
        expect(entry.reload.keywords).to contain_exactly(good_times, journal.keywords.find_by(canonical_keyword: "HardCider"), bad_apple)
      end
    end
  end
end
