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

ActiveRecord::Schema.define(version: 2021_05_17_015521) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "authentication_methods", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "person_id"
    t.string "method", null: false
    t.string "value", null: false
    t.datetime "confirmed_at"
    t.text "one_time_password_secret_ciphertext"
    t.string "encrypted_one_time_password_secret_iv"
    t.datetime "last_one_time_password_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["method", "value"], name: "index_authentication_methods_on_method_and_value", unique: true
    t.index ["person_id"], name: "index_authentication_methods_on_person_id"
  end

  create_table "clients", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "furniture_placements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "slot"
    t.string "furniture_kind"
    t.jsonb "settings"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "room_id"
    t.index ["room_id"], name: "index_furniture_placements_on_room_id"
  end

  create_table "people", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_people_on_email", unique: true
  end

  create_table "room_ownerships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "owner_id"
    t.uuid "room_id"
    t.index ["owner_id"], name: "index_room_ownerships_on_owner_id"
    t.index ["room_id"], name: "index_room_ownerships_on_room_id"
  end

  create_table "rooms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "access_level", default: "unlocked", null: false
    t.string "access_code"
    t.string "publicity_level"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "space_id"
    t.index ["slug", "space_id"], name: "index_rooms_on_slug_and_space_id", unique: true
    t.index ["space_id"], name: "index_rooms_on_space_id"
  end

  create_table "space_memberships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "member_id"
    t.uuid "space_id"
    t.string "access_code"
    t.index ["member_id"], name: "index_space_memberships_on_member_id"
    t.index ["space_id"], name: "index_space_memberships_on_space_id"
  end

  create_table "spaces", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "client_id"
    t.string "jitsi_meet_domain"
    t.string "name"
    t.string "access_level"
    t.string "access_code"
    t.string "slug"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "branded_domain"
    t.uuid "entrance_id"
    t.index ["client_id"], name: "index_spaces_on_client_id"
    t.index ["slug", "client_id"], name: "index_spaces_on_slug_and_client_id", unique: true
  end

  create_table "utility_hookups", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "space_id"
    t.string "name", null: false
    t.string "utility_slug", null: false
    t.string "status", default: "unavailable", null: false
    t.jsonb "configuration"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["space_id"], name: "index_utility_hookups_on_space_id"
  end

  add_foreign_key "spaces", "rooms", column: "entrance_id"
end
