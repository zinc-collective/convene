class AddOrderByAndDeliveryWindowToMarketplaceDeliveryAreas < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      change_table :marketplace_delivery_areas, bulk: true do |t|
        t.string :delivery_window, default: nil
        t.string :order_by, default: nil
      end
    end
  end
end
