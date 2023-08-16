require "rails_helper"

RSpec.describe Journal::KeywordsController, type: :request do
  describe "#show" do
    subject(:perform_request) do
      get polymorphic_path(keyword.location)
      response
    end

    let(:keyword) { create(:journal_keyword, aliases: ["pony"]) }
    let(:journal) { keyword.journal }

    it { is_expected.to be_ok }

    context "when the keyword is of a different case" do
      subject(:perform_request) do
        get polymorphic_path(journal.location(child: :keyword), id: keyword.canonical_keyword.upcase)
        response
      end

      it { is_expected.to redirect_to polymorphic_path(keyword.location) }
    end

    context "when the keyword is an alias" do
      subject(:perform_request) do
        get polymorphic_path(journal.location(child: :keyword), id: "Pony")
        response
      end

      it { is_expected.to redirect_to polymorphic_path(keyword.location) }
    end

    context "when the keyword doesn't exist" do
      subject(:perform_request) do
        get polymorphic_path(journal.location(child: :keyword), id: "Gibberish")
        response
      end

      it { is_expected.to be_not_found }
    end
  end
end
