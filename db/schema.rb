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

ActiveRecord::Schema[7.0].define(version: 2025_06_24_135005) do
  create_table "active_storage_attachments", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb3", force: :cascade do |t|
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

  create_table "active_storage_variant_records", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "counters", charset: "utf8mb3", force: :cascade do |t|
    t.date "eaten_at", null: false
    t.string "store_name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "saved"
    t.index ["user_id"], name: "index_counters_on_user_id"
  end

  create_table "gacha_lists", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.integer "rarity", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "weight", default: 1, null: false
  end

  create_table "sushi_item_counters", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "sushi_item_id", null: false
    t.bigint "counter_id", null: false
    t.integer "count", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["counter_id"], name: "index_sushi_item_counters_on_counter_id"
    t.index ["sushi_item_id"], name: "index_sushi_item_counters_on_sushi_item_id"
  end

  create_table "sushi_items", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "created_by_user_id"
    t.index ["category_id"], name: "index_sushi_items_on_category_id"
  end

  create_table "user_gacha_lists", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "gacha_list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gacha_list_id"], name: "index_user_gacha_lists_on_gacha_list_id"
    t.index ["user_id"], name: "index_user_gacha_lists_on_user_id"
  end

  create_table "user_sushi_item_images", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "sushi_item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sushi_item_id"], name: "index_user_sushi_item_images_on_sushi_item_id"
    t.index ["user_id"], name: "index_user_sushi_item_images_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "coin", default: 3
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "counters", "users"
  add_foreign_key "sushi_item_counters", "counters"
  add_foreign_key "sushi_item_counters", "sushi_items"
  add_foreign_key "sushi_items", "categories"
  add_foreign_key "user_gacha_lists", "gacha_lists"
  add_foreign_key "user_gacha_lists", "users"
  add_foreign_key "user_sushi_item_images", "sushi_items"
  add_foreign_key "user_sushi_item_images", "users"
end
