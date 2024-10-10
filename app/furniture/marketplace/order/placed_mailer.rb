class Marketplace
  class Order
    class PlacedMailer < Mailer
      def to
        order.contact_email
      end

      def reply_to
        order.marketplace.notification_methods.map(&:contact_location)
      end
    end
  end
end
