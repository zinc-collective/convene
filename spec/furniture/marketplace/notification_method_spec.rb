require "rails_helper"

RSpec.describe Marketplace::NotificationMethod, type: :model do
  it { is_expected.to belong_to(:marketplace).inverse_of(:notification_methods) }
end
