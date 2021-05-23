require 'rails_helper'

RSpec.describe AuthenticationMethod, type: :model do
  subject(:authentication_method) { FactoryBot.build(:authentication_method) }


  before { authentication_method.set_one_time_password_secret }

  describe "#contact_method" do
    it { is_expected.to validate_presence_of(:contact_method) }
  end

  describe "#contact_location" do
    it { is_expected.to validate_presence_of(:contact_location) }
  end

  describe "#verify?(one_time_password)" do
    it "is true when the OTP is fresh" do
      authentication_method.last_one_time_password_at = Time.now
      one_time_password = authentication_method.one_time_password

      expect(authentication_method.verify?(one_time_password)).to be_truthy
    end

    it "is false when the OTP is stale" do
      authentication_method.last_one_time_password_at = 3.hours.ago
      one_time_password = authentication_method.one_time_password

      expect(authentication_method.verify?(one_time_password)).to be_falsey
    end
  end

  describe "#send_one_time_password!(space)" do
    let(:space) { FactoryBot.create(:space) }

    it "increments the one time password" do
      expect { authentication_method.send_one_time_password!(space) }
        .to change { authentication_method.last_one_time_password_at }
    end

    it "delivers a one-time-password email for the space" do
      mail = double(deliver_now: true)
      allow(AuthenticatedSessionMailer).to receive(:one_time_password_email).and_return(mail)

      authentication_method.send_one_time_password!(space)
      expect(AuthenticatedSessionMailer).to have_received(:one_time_password_email).with(authentication_method, space)
      expect(mail).to have_received(:deliver_now)
    end
  end
end
