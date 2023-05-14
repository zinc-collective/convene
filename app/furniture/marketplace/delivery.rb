class Marketplace
  class Delivery < Record
    self.table_name = "marketplace_orders"

    belongs_to :marketplace
    belongs_to :shopper
    belongs_to :delivery_area

    has_encrypted :delivery_address
    has_encrypted :contact_phone_number
    has_encrypted :contact_email

    def delivery_window
      delivery_area&.delivery_window
    end
    alias_method :window, :delivery_window

    def fee
      delivery_area&.price.presence || Money.new(0)
    end

    def details_filled_in?
      delivery_address.present? && contact_phone_number.present? && delivery_area.present?
    end
  end
end
