class Marketplace
  class Order
    class PlacedMailer < Mailer
      def to
        order.contact_email
      end
    end
  end
end
