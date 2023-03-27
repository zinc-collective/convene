class Marketplace
  class Order
    class PlacedMailerPreview < MailerPreview
      def notification
        Order::PlacedMailer.notification(full_order)
      end
    end
  end
end
