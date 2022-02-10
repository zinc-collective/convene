# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/spaces/:space_id/rooms/:room_id/furniture/payment_form/payments', type: :request do
  let(:space) { FactoryBot.create(:space) }
  let(:room) { FactoryBot.create(:room, space: space) }
  let!(:plaid_hookup) { FactoryBot.create(:plaid_utility_hookup, space: space) }
  let!(:payment_form) { FactoryBot.create(:payment_form, room: room) }
  let(:neighbor) { FactoryBot.create(:person) }
  let(:space_member) { FactoryBot.create(:person, spaces: [space]) }

  describe 'POST' do
    it 'creates a payment' do
      payment_attributes = attributes_for(:payment_form_payment, :sort_of_real)
      VCR.use_cassette('payment_form/payments/create') do
        post "/spaces/#{space.id}/rooms/#{room.id}/furniture/payment_form/payments",
             { params: { payment_form_payment: payment_attributes } }
      end

      expect(payment_form.payments).not_to be_empty

      payment = payment_form.payments.last

      expect(payment.payer_name).to eql(payment_attributes[:payer_name])
      expect(payment.payer_email).to eql(payment_attributes[:payer_email])
      expect(payment.amount).to eql(payment_attributes[:amount].to_s)
      expect(payment.memo).to eql(payment_attributes[:memo])
      expect(payment.plaid_access_token).to include('access-sandbox')
      expect(payment.plaid_item_id).to be_present
    end
  end

  describe 'GET' do
    let!(:payment) {
      VCR.use_cassette('payment_form/payments/create') do
        payment_form.payments.create!(
          attributes_for(:payment_form_payment, :sort_of_real)
        )
      end
    }

    it 'is a 200 for guests' do
      get "/spaces/#{space.id}/rooms/#{room.id}/furniture/payment_form/payments"

      expect(response).to be_ok
      expect(assigns(:payments)).to be_empty
    end

    it 'is a 200 for neighbors' do
      sign_in(space, neighbor)

      get "/spaces/#{space.id}/rooms/#{room.id}/furniture/payment_form/payments"

      expect(response).to be_ok
      expect(assigns(:payments)).to be_empty
    end

    it 'is a list of the payments for residents' do
      sign_in(space, space_member)

      VCR.use_cassette('payment_form/payments/index') do
        get "/spaces/#{space.id}/rooms/#{room.id}/furniture/payment_form/payments"
      end

      expect(response).to be_ok
      expect(response).to(render_template(:index))
      expect(assigns(:payments)).to be_present
      expect(assigns(:payments)).to include(payment)
    end
  end
end
