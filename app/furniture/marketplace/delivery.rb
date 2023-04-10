class Marketplace
  class Delivery < Record
    self.table_name = "marketplace_orders"

    belongs_to :marketplace
    belongs_to :shopper
    belongs_to :delivery_area

    has_encrypted :delivery_address
    attribute :delivery_window, WindowType.new
    has_encrypted :contact_phone_number
    has_encrypted :contact_email

    def window
      delivery_window
    end

    def fee
      delivery_area&.price.presence || marketplace&.delivery_fee.presence
    end
  end
end
