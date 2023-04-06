class Marketplace
  class Delivery < Order
    attribute :delivery_window, ::Marketplace::Delivery::WindowType.new
  end
end
