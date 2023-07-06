class Marketplace
  class Order
    class ReceivedMailer < Mailer
      def to
        order.marketplace.notification_methods.map(&:contact_location)
      end
    end
  end
end
