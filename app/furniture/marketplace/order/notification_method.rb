# frozen_string_literal: true

class Marketplace
  class Order::NotificationMethod < Record
    self.table_name = :marketplace_order_notification_methods
    location(parent: :marketplace)
    belongs_to :marketplace, inverse_of: :order_notification_methods

    has_encrypted :contact_location
    validates :contact_location, presence: true
  end
end
