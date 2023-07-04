require "rails_helper"
require "cgi"

RSpec.describe Journal::EntriesController, type: :request do
  let(:journal) { create(:journal) }
  let(:space) { journal.space }
  let(:room) { journal.room }
  let(:member) { create(:person, spaces: [space]) }

  before { sign_in(space, member) }

  describe "#index" do
    subject(:perform_request) do
      get polymorphic_path(journal.location(child: :entries))
      response
    end

    let!(:unpublished_entry) { create(:journal_entry, journal: journal) }
    let!(:published_entry) { create(:journal_entry, journal: journal, published_at: 1.week.ago) }

    it { is_expected.to be_ok }

    describe "response body" do
      subject(:response_body) { response.body }

      before { perform_request }

      it { is_expected.to include(CGI.escapeHTML(published_entry.headline)) }
      it { is_expected.to include(CGI.escapeHTML(unpublished_entry.headline)) }
    end
  end

  describe "#create" do
    subject(:perform_request) do
      post polymorphic_path([space, room, journal, :entries]), params: {entry: journal_entry_attributes}
    end

    let(:journal_entry_attributes) { attributes_for(:journal_entry) }
    let(:created_journal_entry) { journal.entries.first }

    specify {
      expect { perform_request }.to change(journal.entries, :count).by(1)
      expect(response).to redirect_to(polymorphic_path(room.location))
      expect(created_journal_entry.headline).to eql(journal_entry_attributes[:headline])
      expect(created_journal_entry.body).to eql(journal_entry_attributes[:body])
    }

    context "when the journal entry cannot be created" do
      let(:journal_entry_attributes) { {headline: ""} }

      specify {
        expect { perform_request }.not_to change(journal.entries, :count)

        expect(response).to be_unprocessable
      }
    end
  end

  describe "#update" do
    subject(:perform_request) do
      put polymorphic_path(entry.location), params: {entry: entry_params}
      entry.reload
      response
    end

    let(:entry_params) { {published_at: 1.day.ago.beginning_of_day} }
    let(:entry) { create(:journal_entry, journal: journal) }

    before { sign_in(space, member) }

    specify do
      expect { perform_request }.to change(entry, :published_at).from(nil).to(entry_params[:published_at].to_time).and(change(entry, :updated_at))

      expect(response).to redirect_to(entry.location)
    end

    context "when the update cannot be saved" do
      let(:entry_params) { {headline: ""} }

      specify do
        expect { perform_request }.not_to change(entry, :updated_at)

        expect(response).to be_unprocessable
      end
    end
  end
end
