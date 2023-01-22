class DropCheckoutsTable < ActiveRecord::Migration[7.0]
  def change
    drop_table "marketplace_checkouts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.uuid "cart_id"
      t.uuid "shopper_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "status", default: "pre_checkout", null: false
      t.string "stripe_session_id"
      t.index ["cart_id"], name: "index_marketplace_checkouts_on_cart_id"
      t.index ["shopper_id"], name: "index_marketplace_checkouts_on_shopper_id"
    end

    add_column "marketplace_carts", :stripe_session_id, :string
  end
end
