class Marketplace
  class Cart
    class Delivery < Cart
      extend StripsNamespaceFromModelName
      location(routed_as: :resource, parent: :cart)
      attribute :delivery_window, ::Marketplace::Delivery::WindowType.new

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
