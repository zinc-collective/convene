require "rails_helper"

RSpec.describe Journal::EntryComponent, type: :component do
  subject(:output) { render_inline(component) }

  let(:component) { described_class.new(entry: entry) }
  let(:entry) { create(:journal_entry, body: "https://www.google.com @zee@weirder.earth #GoodTimes") }

  it { is_expected.to have_link("https://www.google.com", href: "https://www.google.com") }
  it { is_expected.to have_link("#GoodTimes", href: polymorphic_path(entry.journal.keywords.find_by(canonical_keyword: "GoodTimes").location)) }
end
