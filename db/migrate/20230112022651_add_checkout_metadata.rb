class AddCheckoutMetadata < ActiveRecord::Migration[7.0]
  def change
    add_column :marketplace_checkouts, :status, :string, default: "pre_checkout", null: false
    add_column :marketplace_checkouts, :stripe_session_id, :string
  end
end
