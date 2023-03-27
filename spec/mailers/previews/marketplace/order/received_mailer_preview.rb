class Marketplace
  class Order
    class ReceivedMailerPreview < MailerPreview
      def notification
        Order::ReceivedMailer.notification(full_order)
      end
    end
  end
end
