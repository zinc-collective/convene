# frozen_string_literal: true

class Marketplace
  class NotificationMethod < Record
    self.table_name = :marketplace_notification_methods
    location(parent: :marketplace)
    belongs_to :marketplace, inverse_of: :notification_methods

    has_encrypted :contact_location
    validates :contact_location, presence: true
  end
end
