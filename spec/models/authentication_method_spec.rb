# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthenticationMethod, type: :model do
  subject(:authentication_method) { FactoryBot.build(:authentication_method) }

  before { authentication_method.set_one_time_password_secret }

  describe '#contact_method' do
    it { is_expected.to validate_presence_of(:contact_method) }
  end

  describe '#contact_location' do
    it { is_expected.to validate_presence_of(:contact_location) }
    it do
      is_expected.to validate_uniqueness_of(:contact_location)
        .case_insensitive.scoped_to(:contact_method)
    end
  end

  describe '#verify?(one_time_password)' do
    it 'returns true when a valid, fresh OTP is used' do
      authentication_method.last_one_time_password_at = Time.now
      one_time_password = authentication_method.one_time_password

      expect(authentication_method.verify?(one_time_password)).to be_truthy
    end

    it 'returns false when the OTP is stale' do
      authentication_method.last_one_time_password_at = 3.hours.ago
      one_time_password = authentication_method.one_time_password

      expect(authentication_method.verify?(one_time_password)).to be_falsey
    end
  end

  describe '#send_one_time_password!(space)' do
    let(:space) { FactoryBot.create(:space) }

    it 'increments the one time password' do
      expect { authentication_method.send_one_time_password!(space) }
        .to(change { authentication_method.last_one_time_password_at })
    end

    it 'delivers a one-time-password email for the space' do
      expect do
        authentication_method.send_one_time_password!(space)
      end.to have_enqueued_mail(
        AuthenticatedSessionMailer, :one_time_password_email
      ).with(authentication_method, space)
    end
  end
end
