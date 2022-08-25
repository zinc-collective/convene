class Marketplace::Order < Item
  def items
    Marketplace::Item
  end

  def marketplace
    furniture
  end

  def checkout
    Marketplace::Checkout.new(order: self)
  end
end