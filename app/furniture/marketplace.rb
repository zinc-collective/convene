# @see features/furniture/marketplace.feature.md
class Marketplace
  def self.from_placement(placement)
    placement.becomes(Marketplace)
  end
end
