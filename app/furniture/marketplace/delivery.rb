class Marketplace
  class Delivery < Record
    self.table_name = "marketplace_orders"
    attribute :delivery_window, WindowType.new

    def window
      delivery_window
    end
  end
end
