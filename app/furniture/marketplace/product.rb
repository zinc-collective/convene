# frozen_string_literal: true

class Marketplace
  class Product < Record
    include Archivable

    # TODO: Refactor to use Media model
    has_one_attached :photo, dependent: :destroy

    self.table_name = "marketplace_products"
    location(parent: :marketplace)

    extend StripsNamespaceFromModelName

    belongs_to :marketplace, inverse_of: :products
    delegate :space, to: :marketplace

    has_many :cart_products, inverse_of: :product, dependent: :destroy
    has_many :carts, through: :cart_products, inverse_of: :products
    after_discard do
      # This is redonkulus, and due to the inappropriate polymorphism where
      # carts/orders are the same table.
      cart_products.where(cart: carts).destroy_all
    end

    has_many :ordered_products, inverse_of: :product, dependent: :destroy
    has_many :orders, -> { checked_out }, through: :ordered_products, inverse_of: :products

    has_many :product_tags, inverse_of: :product, dependent: :destroy
    has_many :tags, through: :product_tags, inverse_of: :products

    has_many :product_tax_rates, inverse_of: :product, dependent: :destroy
    has_many :tax_rates, through: :product_tax_rates, inverse_of: :products

    attribute :name, :string
    validates :name, presence: true

    has_rich_text :description

    monetize :price_cents

    before_commit :standardize_attachment_name

    def standardize_attachment_name
      return unless photo.attached? && photo.blob.persisted?
      return if photo.blob.filename.to_s.start_with?(space.id.to_s)

      new_name = "#{space.id}-#{photo.blob.filename}"
      photo.blob.update(filename: new_name)
    end
  end
end
