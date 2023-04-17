require "rails_helper"

RSpec.describe Space::AgreementsController do
  let(:space) { create(:space) }
  let(:member) { create(:membership, space: space).member }

  describe "#show" do
    subject(:perform_request) do
      get polymorphic_path([space, agreement])
      response
    end

    let(:agreement) { create(:space_agreement, space: space) }

    it { is_expected.to render_template(:show) }
  end

  describe "#new" do
    subject(:perform_request) do
      get polymorphic_path(space.location(:new, child: :agreement))
      response
    end

    it { is_expected.to be_not_found }

    context "when signed in as a member" do
      before { sign_in(space, member) }

      it { is_expected.to render_template(:new) }

      specify do
        perform_request
        assert_select('input[type="text"][name="agreement[name]"]')
        assert_select('textarea[name="agreement[body]"]')
      end
    end
  end

  describe "#create" do
    subject(:perform_request) do
      post polymorphic_path(space.location(child: :agreements)), params: {agreement: agreement_params}
      response
    end

    let(:agreement_params) { attributes_for(:space_agreement) }

    it { is_expected.to be_not_found }

    context "when signed in as a member" do
      before { sign_in(space, member) }

      specify do
        perform_request
        expect(space.reload.agreements).to exist(name: agreement_params[:name], body: agreement_params[:body])
      end

      it { is_expected.to redirect_to(space.location(:edit)) }
    end

    context "when the agreement is invalid" do
      before { sign_in(space, member) }

      let(:agreement_params) { attributes_for(:space_agreement, name: nil) }

      it { is_expected.to render_template(:new) }

      it { is_expected.to be_unprocessable }
      specify { expect { perform_request }.not_to change { space.agreements.reload.count } }
    end
  end

  describe "#destroy" do
    subject(:perform_request) do
      delete polymorphic_path(agreement.location)
      response
    end

    let(:agreement) { create(:space_agreement, space: space) }

    it { is_expected.to be_not_found }

    context "when signed in as a member" do
      before { sign_in(space, member) }

      specify do
        perform_request
        expect(Space::Agreement).not_to exist(id: agreement.id)
      end

      it { is_expected.to redirect_to(space.location(:edit)) }
    end
  end
end
