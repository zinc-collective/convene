# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_02_07_040004) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_enum :invitation_status, [
    "pending",
    "accepted",
    "rejected",
    "expired",
    "ignored",
    "revoked",
    "sent",
  ], force: :cascade

  create_enum :membership_status, [
    "active",
    "revoked",
  ], force: :cascade

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "authentication_methods", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "person_id"
    t.string "contact_method", null: false
    t.string "contact_location", null: false
    t.datetime "confirmed_at", precision: nil
    t.text "one_time_password_secret_ciphertext"
    t.string "encrypted_one_time_password_secret_iv"
    t.datetime "last_one_time_password_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_method", "contact_location"], name: "index_authentication_methods_on_contact_fields", unique: true
    t.index ["person_id"], name: "index_authentication_methods_on_person_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at", precision: nil
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "furnitures", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "slot"
    t.string "furniture_kind"
    t.jsonb "settings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "room_id"
    t.text "secrets_ciphertext"
    t.index ["room_id"], name: "index_furnitures_on_room_id"
  end

  create_table "invitations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "space_id"
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "last_sent_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "invitor_id"
    t.enum "status", default: "pending", null: false, enum_type: "invitation_status"
    t.index ["invitor_id"], name: "index_invitations_on_invitor_id"
    t.index ["space_id"], name: "index_invitations_on_space_id"
  end

  create_table "journal_entries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "journal_id"
    t.string "headline"
    t.text "body"
    t.string "slug"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "keywords", array: true
    t.text "summary"
    t.index ["journal_id"], name: "index_journal_entries_on_journal_id"
  end

  create_table "journal_keywords", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "journal_id"
    t.string "canonical_keyword"
    t.string "aliases", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["journal_id"], name: "index_journal_keywords_on_journal_id"
  end

  create_table "marketplace_cart_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "cart_id"
    t.uuid "product_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_marketplace_cart_products_on_cart_id"
    t.index ["product_id"], name: "index_marketplace_cart_products_on_product_id"
  end

  create_table "marketplace_delivery_areas", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "marketplace_id"
    t.string "label"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "delivery_window"
    t.string "order_by"
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_marketplace_delivery_areas_on_discarded_at"
    t.index ["marketplace_id"], name: "index_marketplace_delivery_areas_on_marketplace_id"
  end

  create_table "marketplace_events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "regarding_type"
    t.uuid "regarding_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["regarding_type", "regarding_id"], name: "index_marketplace_events_on_regarding"
  end

  create_table "marketplace_notification_methods", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "marketplace_id"
    t.string "contact_method", default: "email", null: false
    t.string "contact_location_ciphertext", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["marketplace_id"], name: "index_marketplace_notification_methods_on_marketplace_id"
  end

  create_table "marketplace_orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "marketplace_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "shopper_id"
    t.string "status", default: "pre_checkout", null: false
    t.string "stripe_session_id"
    t.text "delivery_address_ciphertext"
    t.string "contact_phone_number_ciphertext"
    t.datetime "placed_at"
    t.string "delivery_notes"
    t.string "contact_email_ciphertext"
    t.uuid "delivery_area_id"
    t.integer "payment_processor_fee_cents", default: 0, null: false
    t.string "payment_processor_fee_currency", default: "USD", null: false
    t.string "stripe_transfer_id"
    t.index ["delivery_area_id"], name: "index_marketplace_orders_on_delivery_area_id"
    t.index ["marketplace_id"], name: "index_marketplace_orders_on_marketplace_id"
    t.index ["shopper_id"], name: "index_marketplace_orders_on_shopper_id"
  end

  create_table "marketplace_product_tax_rates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "tax_rate_id"
    t.uuid "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_marketplace_product_tax_rates_on_product_id"
    t.index ["tax_rate_id"], name: "index_marketplace_product_tax_rates_on_tax_rate_id"
  end

  create_table "marketplace_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "marketplace_id"
    t.string "name"
    t.string "description"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.integer "servings"
    t.index ["discarded_at"], name: "index_marketplace_products_on_discarded_at"
    t.index ["marketplace_id"], name: "index_marketplace_products_on_marketplace_id"
  end

  create_table "marketplace_shoppers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_marketplace_shoppers_on_person_id", unique: true
  end

  create_table "marketplace_tax_rates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.float "tax_rate"
    t.string "label"
    t.uuid "marketplace_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "bazaar_id"
    t.index ["bazaar_id"], name: "index_marketplace_tax_rates_on_bazaar_id"
    t.index ["marketplace_id"], name: "index_marketplace_tax_rates_on_marketplace_id"
  end

  create_table "marketplace_vendor_representatives", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "marketplace_id"
    t.uuid "person_id"
    t.string "email_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["marketplace_id"], name: "index_marketplace_vendor_representatives_on_marketplace_id"
    t.index ["person_id"], name: "index_marketplace_vendor_representatives_on_person_id"
  end

  create_table "media", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "memberships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "member_id"
    t.uuid "space_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "invitation_id"
    t.enum "status", default: "active", null: false, enum_type: "membership_status"
    t.index ["invitation_id"], name: "index_memberships_on_invitation_id"
    t.index ["member_id"], name: "index_memberships_on_member_id"
    t.index ["space_id"], name: "index_memberships_on_space_id"
  end

  create_table "people", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "operator", default: false
    t.index ["email"], name: "index_people_on_email", unique: true
  end

  create_table "rooms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "access_level", default: "public", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "space_id"
    t.string "description"
    t.uuid "hero_image_id"
    t.index ["slug", "space_id"], name: "index_rooms_on_slug_and_space_id", unique: true
    t.index ["space_id"], name: "index_rooms_on_space_id"
  end

  create_table "space_agreements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "space_id"
    t.string "name", null: false
    t.string "slug", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["space_id", "name"], name: "index_space_agreements_on_space_id_and_name", unique: true
    t.index ["space_id", "slug"], name: "index_space_agreements_on_space_id_and_slug", unique: true
    t.index ["space_id"], name: "index_space_agreements_on_space_id"
  end

  create_table "spaces", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "client_id"
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "branded_domain"
    t.uuid "entrance_id"
    t.boolean "enforce_ssl", default: false, null: false
    t.index ["client_id"], name: "index_spaces_on_client_id"
    t.index ["slug", "client_id"], name: "index_spaces_on_slug_and_client_id", unique: true
  end

  create_table "utility_hookups", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "space_id"
    t.string "name", null: false
    t.string "utility_slug", null: false
    t.string "status", default: "unavailable", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "configuration_ciphertext"
    t.index ["space_id"], name: "index_utility_hookups_on_space_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "journal_entries", "furnitures", column: "journal_id"
  add_foreign_key "journal_keywords", "furnitures", column: "journal_id"
  add_foreign_key "marketplace_cart_products", "marketplace_orders", column: "cart_id"
  add_foreign_key "marketplace_cart_products", "marketplace_products", column: "product_id"
  add_foreign_key "marketplace_delivery_areas", "furnitures", column: "marketplace_id"
  add_foreign_key "marketplace_notification_methods", "furnitures", column: "marketplace_id"
  add_foreign_key "marketplace_orders", "marketplace_delivery_areas", column: "delivery_area_id"
  add_foreign_key "marketplace_orders", "marketplace_shoppers", column: "shopper_id"
  add_foreign_key "marketplace_product_tax_rates", "marketplace_products", column: "product_id"
  add_foreign_key "marketplace_product_tax_rates", "marketplace_tax_rates", column: "tax_rate_id"
  add_foreign_key "marketplace_products", "furnitures", column: "marketplace_id"
  add_foreign_key "marketplace_shoppers", "people"
  add_foreign_key "marketplace_tax_rates", "furnitures", column: "marketplace_id"
  add_foreign_key "marketplace_tax_rates", "spaces", column: "bazaar_id"
  add_foreign_key "marketplace_vendor_representatives", "furnitures", column: "marketplace_id"
  add_foreign_key "marketplace_vendor_representatives", "people"
  add_foreign_key "memberships", "invitations"
  add_foreign_key "rooms", "media", column: "hero_image_id"
  add_foreign_key "space_agreements", "spaces"
  add_foreign_key "spaces", "rooms", column: "entrance_id"
end
