require "rails_helper"

RSpec.describe Space::AgreementsController do
  describe "#show" do
    subject(:perform_request) do
      get polymorphic_path([space, agreement])
      response
    end

    let(:space) { agreement.space }
    let(:agreement) { create(:space_agreement) }

    it { is_expected.to render_template(:show) }
  end
end
