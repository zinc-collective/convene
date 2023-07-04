require "rails_helper"

RSpec.describe Journal::Entry, type: :model do
  subject(:entry) { build(:journal_entry) }

  it { is_expected.to validate_presence_of(:headline) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to strip_attributes(:slug, :body, :headline) }
  it { is_expected.to belong_to(:journal).inverse_of(:entries) }
  it { is_expected.to have_one(:room).through(:journal) }
  it { is_expected.to have_one(:space).through(:journal) }
  it { is_expected.to have_many(:terms).through(:journal) }

  describe "#to_html" do
    subject(:to_html) { entry.to_html }

    context "when #body is 'https://www.google.com @zee@weirder.earth #GoodTimes'" do
      let(:entry) { build(:journal_entry, body: "https://www.google.com @zee@weirder.earth #GoodTimes") }

      it { is_expected.to include('<a href="https://www.google.com">https://www.google.com</a>') }
      # it { is_expected.to include('<a href="../terms/GoodTimes">#GoodTimes</a>') }
    end
  end

  describe "#save" do
    let(:entry) { create(:journal_entry, body: "#GoodTimes") }

    context "when the body is changing" do
      it "idempotently creates terms in the journal" do
        bad_apple = entry.journal.terms.create!(canonical_term: "BadApple", aliases: "BadApples")
        good_times = entry.journal.terms.create!(canonical_term: "GoodTimes")
        expect do
          entry.update!(body: "#GoodTimes #HardCider #BadApples")
        end.not_to change { "#{bad_apple.reload.updated_at} - #{good_times.reload.updated_at}" }

        expect(Journal::Term.where(canonical_term: "GoodTimes")).to exist
        expect(Journal::Term.where(canonical_term: "HardCider")).to exist
        expect(Journal::Term.where(canonical_term: "BadApples")).not_to exist
      end
    end
  end
end
