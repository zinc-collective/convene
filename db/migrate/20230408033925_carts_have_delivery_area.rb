class CartsHaveDeliveryArea < ActiveRecord::Migration[7.0]
  def change
    add_reference :marketplace_orders, :delivery_area, type: :uuid, foreign_key: {to_table: :marketplace_delivery_areas}
  end
end
