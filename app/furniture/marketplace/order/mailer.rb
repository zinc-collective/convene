class Marketplace
  class Order
    class Mailer < ApplicationMailer
      attr_reader :order
      helper_method :order

      def notification(order)
        @order = order
        mail(to: to,
          subject: t(".subject", marketplace_name: order.marketplace.room.name,
            order_id: order.id))
      end
    end
  end
end
