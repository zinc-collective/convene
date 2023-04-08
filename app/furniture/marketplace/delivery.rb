class Marketplace
  class Delivery < Record
    self.table_name = "marketplace_orders"

    belongs_to :marketplace
    belongs_to :shopper
    belongs_to :delivery_area
    validates :delivery_area_id, presence: true # rubocop:disable Rails/RedundantPresenceValidationOnBelongsTo

    attribute :delivery_window, WindowType.new

    def window
      delivery_window
    end

    def fee
      delivery_area&.price.presence || marketplace&.delivery_fee.presence
    end
  end
end
