class Marketplace
  class Order
    class EmailReceiptComponent < ApplicationComponent
      renders_one :placed_at

      attr_accessor :order
      def initialize(order)
        self.order = order
      end

      def dom_id
        super(order, :email_receipt)
      end
    end
  end
end
