class Marketplace
  class Cart
    class Delivery < ::Marketplace::Delivery
      extend StripsNamespaceFromModelName
      location(routed_as: :resource, parent: :cart)

      validates :contact_email, presence: true
      validates :contact_phone_number, presence: true
      validates :delivery_address, presence: true

      def cart
        @cart ||= becomes(Cart)
      end
    end
  end
end
