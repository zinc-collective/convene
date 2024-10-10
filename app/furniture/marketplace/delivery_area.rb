class Marketplace
  class DeliveryArea < Record
    include Archivable

    self.table_name = "marketplace_delivery_areas"
    location(parent: :marketplace)

    belongs_to :marketplace, inverse_of: :delivery_areas
    has_many :orders, -> { checked_out }, inverse_of: :delivery_area
    has_many :carts, inverse_of: :delivery_area, dependent: :nullify
    after_discard do
      carts.update_all(delivery_area_id: nil) # rubocop:disable Rails/SkipsModelValidations
    end

    has_many :deliveries, inverse_of: :delivery_area

    attribute :delivery_window
    monetize :price_cents

    def delivery_fee(subtotal: nil)
      if charges_fee_as_price? && !charges_fee_as_percentage?
        price
      elsif charges_fee_as_price? && charges_fee_as_percentage? && subtotal.present?
        price + fee_as_percentage_of(subtotal:)
      elsif !charges_fee_as_price? && charges_fee_as_percentage? && subtotal.present?
        fee_as_percentage_of(subtotal:)
      end
    end

    def charges_fee_as_percentage?
      fee_as_percentage.present? && fee_as_percentage.positive?
    end

    def charges_fee_as_price?
      price.present? && price.positive?
    end

    def fee_as_percentage_of(subtotal:)
      subtotal * (fee_as_percentage.to_f / 100)
    end
  end
end
