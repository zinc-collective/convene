class Marketplace
  class OrderReceivedMailer < ApplicationMailer
    attr_reader :order
    helper_method :order
    def notification(order)
      @order = order
      mail(to: order.marketplace.notify_emails.split(","),
        subject: t(".subject", marketplace_name: order.marketplace.room.name,
          order_id: order.id))
    end
  end
end
