require "rails_helper"

RSpec.describe Journal::Entry, type: :model do
  subject(:entry) { build(:journal_entry) }

  it { is_expected.to validate_presence_of(:headline) }
  it { is_expected.to validate_presence_of(:body) }

  describe "#to_html" do
    subject(:to_html) { entry.to_html }

    let(:entry) { build(:journal_entry, body: body) }

    context "when #body is 'https://www.google.com @zee@weirder.earth'" do
      let(:body) { "https://www.google.com @zee@weirder.earth" }

      it { is_expected.to include('<a href="https://weirder.earth/@zee">@zee@weirder.earth</a>') }
      it { is_expected.to include('<a href="https://www.google.com">https://www.google.com</a>') }
    end
  end
end
