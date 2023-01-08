class Marketplace
  class OrderedProduct < CartProduct
    include WithinLocation
    self.location_parent = :checkout

    has_one :checkout, through: :cart
  end
end
