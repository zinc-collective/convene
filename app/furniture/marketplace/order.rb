class Marketplace::Order < Item
  def items
    Marketplace::Item
  end

  def marketplace
    furniture
  end
end