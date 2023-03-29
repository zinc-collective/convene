class Marketplace
  class Order
    class ReceivedMailer < Mailer
      def to
        order.marketplace.notify_emails.split(",")
      end
    end
  end
end
