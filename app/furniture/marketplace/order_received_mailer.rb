class Marketplace
  class OrderReceivedMailer < ApplicationMailer
    attr_reader :order
    helper_method :order
    def notification(order)
      @order = order
      mail(to: order.marketplace.notify_emails.split(","))
    end
  end
end
