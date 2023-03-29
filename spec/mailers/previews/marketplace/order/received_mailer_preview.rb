class Marketplace
  class Order
    class ReceivedMailerPreview < ActionMailer::Preview
      def notification
        Order::ReceivedMailer.notification(FactoryBot.build(:marketplace_order, :full))
      end
    end
  end
end
