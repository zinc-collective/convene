class Marketplace
  class OrderPlacedMailer < ApplicationMailer
    attr_reader :order
    helper_method :order
    def notification(order)
      @order = order
      mail(to: order.contact_email,
        subject: t(".subject", marketplace_name: order.marketplace.room.name,
          order_id: order.id))
    end
  end
end
