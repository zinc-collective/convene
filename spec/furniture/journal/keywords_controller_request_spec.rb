require "rails_helper"

RSpec.describe Journal::KeywordsController, type: :request do
  describe "#show" do
    subject(:perform_request) do
      get polymorphic_path(keyword.location)
      response
    end

    context "when the :id is the keyword's id" do
      it { is_expected.to be_ok }

      it "has a canonical entry in the head to the canonical keyword based url"
    end

    context "when the :id is a canonical keyword" do
      it { is_expected.to be_ok }
    end

    context "when the :id is an alias" do
      it { is_expected.to be_ok }

      it "has a canonical entry in the head to the canonical keyword based url"
    end
  end
end
