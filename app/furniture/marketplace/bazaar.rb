class Marketplace
  # Serves as a connection point for cross-marketplace functionality, like
  # {TaxRate} and {Shopper}.
  class Bazaar < ::Space
    has_many :marketplaces, through: :rooms, source: :furnitures, inverse_of: :bazaar, class_name: "Marketplace"
    has_many :tax_rates, inverse_of: :bazaar, dependent: :destroy

    def space
      becomes(Space)
    end
  end
end
