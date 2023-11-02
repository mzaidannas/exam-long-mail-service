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

ActiveRecord::Schema[7.0].define(version: 2022_07_25_140322) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "roles", ["operator", "postmaster", "owner"]
  create_enum "shipping_statuses", ["pending", "picked", "delivered", "retrieved"]
  create_enum "train_statuses", ["waiting", "booked", "reached", "withdrawn"]

  create_table "booking_parcels", force: :cascade do |t|
    t.bigint "booking_id", null: false
    t.bigint "parcel_id", null: false
    t.index ["booking_id", "parcel_id"], name: "index_booking_parcels_on_booking_id_and_parcel_id", unique: true
    t.index ["booking_id"], name: "index_booking_parcels_on_booking_id"
    t.index ["parcel_id"], name: "index_booking_parcels_on_parcel_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "train_id", null: false
    t.bigint "user_id", null: false
    t.string "line", limit: 1, null: false
    t.datetime "end_time", default: -> { "(CURRENT_TIMESTAMP + 'PT3H'::interval)" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["end_time"], name: "index_bookings_on_end_time", using: :brin
    t.index ["line"], name: "index_bookings_on_line", using: :hash
    t.index ["train_id"], name: "index_bookings_on_train_id", unique: true
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "lines", force: :cascade do |t|
    t.string "name", limit: 1, null: false
    t.boolean "booked", default: false, null: false
    t.index ["booked"], name: "index_lines_on_booked"
    t.index ["name"], name: "index_lines_on_name", using: :hash
  end

  create_table "parcels", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "train_id"
    t.integer "cost"
    t.float "weight", null: false
    t.float "volume", null: false
    t.enum "status", default: "pending", null: false, enum_type: "shipping_statuses"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_parcels_on_status", using: :hash
    t.index ["train_id"], name: "index_parcels_on_train_id"
    t.index ["user_id"], name: "index_parcels_on_user_id"
  end

  create_table "trains", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", limit: 255, null: false
    t.integer "cost", null: false
    t.float "weight", null: false
    t.float "volume", null: false
    t.string "lines", limit: 1, default: [], null: false, array: true
    t.enum "status", default: "waiting", null: false, enum_type: "train_statuses"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lines"], name: "index_trains_on_lines", using: :gin
    t.index ["status"], name: "index_trains_on_status", using: :hash
    t.index ["user_id"], name: "index_trains_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.string "email", limit: 256, null: false
    t.enum "role", default: "owner", null: false, enum_type: "roles"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "jti", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "booking_parcels", "bookings"
  add_foreign_key "booking_parcels", "parcels"
  add_foreign_key "bookings", "trains"
  add_foreign_key "bookings", "users"
  add_foreign_key "parcels", "users"
  add_foreign_key "trains", "users"
end
