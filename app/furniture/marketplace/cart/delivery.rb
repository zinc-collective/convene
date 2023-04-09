class Marketplace
  class Cart
    class Delivery < Cart
      extend StripsNamespaceFromModelName
      location(routed_as: :resource, parent: :cart)
      attribute :delivery_window, ::Marketplace::Delivery::WindowType.new
      def window
        delivery_window
      end

      belongs_to :delivery_area
      validates :delivery_area_id, presence: true # rubocop:disable Rails/RedundantPresenceValidationOnBelongsTo

      validates :contact_email, presence: true
      validates :contact_phone_number, presence: true
      validates :delivery_address, presence: true
      validates :delivery_window, presence: true

      def cart
        @cart ||= becomes(Cart)
      end
    end
  end
end
