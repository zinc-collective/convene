class AddStatusToCart < ActiveRecord::Migration[7.0]
  def change
    add_column :marketplace_carts, :status, :string, default: "pre_checkout", null: false
  end
end
