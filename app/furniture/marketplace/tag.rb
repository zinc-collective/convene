class Marketplace
  class Tag < Record
    self.table_name = "marketplace_tags"

    belongs_to :marketplace, inverse_of: :tags
    has_many :product_tags, inverse_of: :tag, dependent: :destroy
    has_many :products, through: :product_tags, inverse_of: :tags

    validates :label, uniqueness: {case_sensitive: false, scope: :marketplace_id}

    location(parent: :marketplace)

    positioned on: :marketplace

    # Tacking `_tag` onto the end of this scope name solely to avoid
    # collisions with ActiveRecord `groups`
    scope :group_tag, -> { where(is_group: true) }
    scope :not_group, -> { where(is_group: false) }
    scope :by_position, -> { order(position: :asc) }
  end
end
