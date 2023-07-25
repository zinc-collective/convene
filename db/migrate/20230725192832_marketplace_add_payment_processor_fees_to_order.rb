class MarketplaceAddPaymentProcessorFeesToOrder < ActiveRecord::Migration[7.0]
  def change
    add_monetize :marketplace_orders, :payment_processor_fee, null: true, default: nil
  end
end
