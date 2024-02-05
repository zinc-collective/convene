require "rails_helper"

# @see https://github.com/zinc-collective/convene-journal/issues/2
RSpec.describe "Writing Entries", type: :system do
  let(:space) { create(:space, :with_entrance, :with_members) }
  let(:journal) { create(:journal, room: space.entrance) }

  before do
    sign_in(space.members.first, space)
  end

  it "saves the headline, summary and body" do # rubocop:disable RSpec/ExampleLength
    visit(polymorphic_path(journal.location(:new, child: :entry)))

    body = 1000.times.map { Faker::Books::Dune.quote }.join("\n\n")
    fill_in("Headline", with: "1000 Dune Quotes")
    fill_in("Body", with: body)
    summary = %(
      So you thought you wanted 1000 Dune Quotes?
      Well, you were wrong. But here they are anyway!
    )
    fill_in("Summary", with: summary)

    click_button("Create")
    entry = journal.entries.last
    expect(entry.headline).to eq("1000 Dune Quotes")
    expect(entry.body).to eq(body)
    expect(entry.summary).to eq(summary)
  end
end
