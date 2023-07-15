require "rails_helper"

RSpec.describe Journal::KeywordsController, type: :request do
  describe "#show" do
    subject(:perform_request) do
      get polymorphic_path(keyword.location)
      response
    end

    let(:keyword) { create(:journal_keyword) }

    it { is_expected.to be_ok }
  end
end
