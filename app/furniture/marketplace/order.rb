class Marketplace
  class Order < Checkout
    self.location_parent = :marketplace
  end
end
