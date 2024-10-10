class MarketplaceAddFeeAsPercentageToDeliveryAreas < ActiveRecord::Migration[7.1]
  def change
    add_column :marketplace_delivery_areas, :fee_as_percentage, :integer
  end
end
