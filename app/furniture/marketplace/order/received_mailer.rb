class Marketplace
  class Order
    class ReceivedMailer < Mailer
      def to
        order.marketplace.notification_methods.map(&:contact_location)
      end

      def reply_to
        order.contact_email
      end
    end
  end
end
