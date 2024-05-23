class Marketplace
  class Tag < Record
    self.table_name = "marketplace_tags"

    belongs_to :marketplace, inverse_of: :tags
    has_many :product_tags, inverse_of: :tag, dependent: :destroy
    has_many :products, through: :product_tags, inverse_of: :tags

    validates :label, uniqueness: {case_sensitive: false, scope: :marketplace_id}

    location(parent: :marketplace)
  end
end
