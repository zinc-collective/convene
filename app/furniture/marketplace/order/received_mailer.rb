class Marketplace
  class Order
    class ReceivedMailer < Mailer
      def to
        order.marketplace.notify_emails.split(",") + order.marketplace.order_notification_methods.map(&:contact_location)
      end
    end
  end
end
