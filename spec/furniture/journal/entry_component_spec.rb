require "rails_helper"

RSpec.describe Journal::EntryComponent, type: :component do
  subject(:output) { render_inline(component) }

  let(:component) { described_class.new(entry: entry) }
  let(:entry) { create(:journal_entry, body: "https://www.google.com zee@example.com @zee@weirder.earth #GoodTime and #GoodTimes with the #GoodTimesBand", journal: journal) }

  let(:journal) do
    create(:journal).tap do |journal|
      journal.keywords.create(canonical_keyword: "GoodTime", aliases: ["GoodTimes"])
    end
  end

  it { is_expected.to have_link("@zee@weirder.earth", href: "https://weirder.earth/@zee") }

  it { is_expected.to have_link("https://www.google.com", href: "https://www.google.com") }

  it { is_expected.to have_link("#GoodTimes", href: polymorphic_path(journal.keywords.find_by(canonical_keyword: "GoodTime").location)) }
  it { is_expected.to have_link("#GoodTime", href: polymorphic_path(journal.keywords.find_by(canonical_keyword: "GoodTime").location)) }
  it { is_expected.to have_link("#GoodTimesBand", href: polymorphic_path(journal.keywords.find_by(canonical_keyword: "GoodTimesBand").location)) }
end
