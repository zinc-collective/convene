class Marketplace
  class Delivery < Record
    self.table_name = "marketplace_orders"
    belongs_to :marketplace
    belongs_to :shopper
    attribute :delivery_window, WindowType.new

    def window
      delivery_window
    end
  end
end
