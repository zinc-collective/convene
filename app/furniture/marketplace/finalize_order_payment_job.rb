# frozen_string_literal: true

class Marketplace
  class FinalizeOrderPaymentJob < ApplicationJob
    def perform(order_id, charge_id)
      return unless (self.order = Order.find_by(id: order_id))

      order.events.create(description: "Payment Received")
      order.marketplace.square_connection&.send_order(order, charge_id)
      sent_notification_to_counterparties
      sent_notification_to_buyer
      SplitJob.perform_later(order: order)
    end

    private

    attr_accessor :order

    def sent_notification_to_counterparties
      Order::ReceivedMailer.notification(order).deliver_later
      order.events.create(description: "Notifications to Vendor and Distributor Sent")
    end

    def sent_notification_to_buyer
      Order::PlacedMailer.notification(order).deliver_later
      order.events.create(description: "Notification to Buyer Sent")
    end
  end
end
