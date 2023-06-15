require "rails_helper"

RSpec.describe Marketplace::OrderNotificationMethod, type: :model do
  it { is_expected.to belong_to(:marketplace).inverse_of(:order_notification_methods) }
end
