require "rails_helper"

RSpec.describe Marketplace::NotificationMethodsController, type: :request do
  let(:marketplace) { create(:marketplace) }
  let(:space) { marketplace.space }
  let(:room) { marketplace.room }
  let(:member) { create(:membership, space: space).member }
  let(:notification_method) { create(:marketplace_notification_method, marketplace: marketplace) }

  before do
    sign_in(space, member)
  end

  describe "#new" do
    subject(:perform_request) do
      get polymorphic_path(marketplace.location(:new, child: :notification_method))
      response
    end

    it { is_expected.to have_rendered(:new) }
  end

  describe "#create" do
    subject(:perform_request) do
      post polymorphic_path(marketplace.location(child: :notification_methods)),
        params: {notification_method: notification_method_attributes}
      response
    end

    let(:notification_method_attributes) { attributes_for(:marketplace_notification_method) }

    specify { expect { perform_request }.to change(marketplace.notification_methods, :count).by(1) }

    describe "the created order notification" do
      let(:created_notification_method) { marketplace.notification_methods.last }

      before { perform_request }

      specify { expect(created_notification_method.contact_method).to eql("email") }
      specify { expect(created_notification_method.contact_location).to eql(notification_method_attributes[:contact_location]) }
    end

    describe "when request is invalid" do
      let(:notification_method_attributes) { {contact_method: "email"} }

      it { is_expected.to have_rendered(:new) }
    end
  end

  describe "#edit" do
    subject(:perform_request) do
      get polymorphic_path(notification_method.location(:edit))
      response
    end

    it { is_expected.to have_rendered(:edit) }
  end

  describe "#update" do
    subject(:perform_request) do
      put polymorphic_path(notification_method.location),
        params: {notification_method: notification_method_attributes}
      notification_method.reload
      response
    end

    let(:notification_method_attributes) { attributes_for(:marketplace_notification_method) }

    specify { expect { perform_request }.to change(notification_method, :contact_location).to notification_method_attributes[:contact_location] }

    it { is_expected.to redirect_to(polymorphic_path(marketplace.location(child: :notification_methods))) }
  end

  describe "#destroy" do
    subject(:perform_request) do
      delete polymorphic_path(notification_method.location)

      response
    end

    it "destroys the NotificationMethod" do
      expect { perform_request && notification_method.reload }.to(raise_error(ActiveRecord::RecordNotFound))
    end

    it { is_expected.to redirect_to(polymorphic_path(marketplace.location(child: :notification_methods))) }
  end
end
