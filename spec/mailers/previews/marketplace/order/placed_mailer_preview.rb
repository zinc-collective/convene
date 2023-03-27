class Marketplace
  class Order
    class PlacedMailerPreview < ActionMailer::Preview
      def notification
        Order::PlacedMailer.notification(FactoryBot.build(:marketplace_order, :full))
      end
    end
  end
end
