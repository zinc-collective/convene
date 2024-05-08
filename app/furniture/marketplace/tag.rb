class Marketplace
  class Tag < Record
    self.table_name = "marketplace_tags"

    belongs_to :bazaar, inverse_of: :tags
    has_many :product_tags, inverse_of: :tag, dependent: :destroy
    has_many :products, through: :product_tags, inverse_of: :tags

    validates :label, uniqueness: {case_sensitive: false, scope: :bazaar_id}

    attr_accessor :marketplace
    location(parent: :marketplace)

    positioned

    scope :without_group, -> { where(is_group: false) }
    scope :ordered_tag_groups, -> { where(is_group: true).merge(order(position: :asc, updated_at: :desc)) }
  end
end
