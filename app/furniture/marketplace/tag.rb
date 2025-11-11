class Marketplace
  class Tag < Record
    self.table_name = "marketplace_tags"

    belongs_to :marketplace, inverse_of: :tags
    has_many :product_tags, inverse_of: :tag, dependent: :destroy
    has_many :products, through: :product_tags, inverse_of: :tags
    # has_many :menu_tag_products, -> { menu_tag_product }, through: :product_tags, source: :product, inverse_of: :tags
    # has_many :menu_products, -> { menu_product }, through: :product_tags, source: :product, inverse_of: :tags

    validates :label, uniqueness: {case_sensitive: false, scope: :marketplace_id}

    location(parent: :marketplace)

    positioned on: :marketplace

    # Tacking `_tag` onto the end of this scope name solely to avoid
    # collisions with ActiveRecord `groups`
    scope :menu_tag, -> { where(is_menu: true) }
    scope :not_menu, -> { where(is_menu: false) }
    scope :by_position, -> { order(position: :asc) }
  end
end
