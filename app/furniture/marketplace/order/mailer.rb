class Marketplace
  class Order
    class Mailer < ApplicationMailer
      attr_reader :order
      helper_method :order

      def notification(order)
        @order = order
        mail(to: to, reply_to: reply_to,
          subject: t(".subject", marketplace_name: order.marketplace_name,
            order_id: order.id))
      end
    end
  end
end
