# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2025_01_08_064303) do

  create_table "air_mails", force: :cascade do |t|
    t.string "mail_no"
    t.string "sender_province_name"
    t.string "sender_city_name"
    t.string "sender_county_name"
    t.decimal "real_weight"
    t.decimal "fee_weight"
    t.decimal "order_weight"
    t.decimal "postage_paid"
    t.decimal "postage_total"
    t.datetime "posting_date"
    t.string "transfer_type"
    t.datetime "flight_date"
    t.string "last_unit_name"
    t.datetime "last_op_at"
    t.string "last_op_desc"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "arrive_jm_at"
    t.string "flight_number"
    t.string "direction"
    t.integer "post_unit_id"
    t.integer "last_unit_id"
    t.string "post_unit_no"
    t.string "post_unit_name"
    t.string "last_unit_no"
    t.string "status"
    t.string "whereis"
    t.string "transfer_center_unit_no"
    t.boolean "is_arrive_jm", default: false
    t.boolean "is_leave_jm", default: false
    t.boolean "is_arrive_center", default: false
    t.boolean "is_leave_center", default: false
    t.boolean "is_leave_center_in_time", default: false
    t.boolean "is_arrive_sub", default: false
    t.boolean "is_in_delivery", default: false
    t.boolean "is_delivered_in_time", default: false
    t.datetime "leave_jm_at"
    t.datetime "arrive_center_at"
    t.datetime "leave_center_at"
    t.datetime "arrive_sub_at"
    t.datetime "leave_sub_at"
    t.datetime "in_delivery_at"
    t.datetime "delivered_at"
    t.index "\"last_unit\", \"is_arrive_sub\", \"is_in_delivery\", \"is_delivered_in_time\"", name: "index_air_mail_delivery_report"
    t.index ["direction"], name: "index_air_mails_on_direction"
    t.index ["flight_number"], name: "index_air_mails_on_flight_number"
    t.index ["is_arrive_jm", "is_leave_jm"], name: "index_air_mail_jm_report"
    t.index ["last_unit_id"], name: "index_air_mails_on_last_unit_id"
    t.index ["mail_no"], name: "index_air_mails_on_mail_no"
    t.index ["post_unit_id"], name: "index_air_mails_on_post_unit_id"
    t.index ["transfer_center_unit_no", "is_arrive_center", "is_leave_center", "is_leave_center_in_time"], name: "index_air_mail_center_report"
  end

  create_table "areas", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.boolean "is_prov"
    t.boolean "is_city"
    t.boolean "is_dist"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_areas_on_code"
  end

  create_table "businesses", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.string "btype"
    t.string "industry"
    t.integer "time_limit"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_init_expresses_midday"
    t.boolean "is_all_visible"
    t.boolean "static_alert"
    t.boolean "is_international", default: false
    t.index ["btype"], name: "index_businesses_on_btype"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name", null: false
    t.integer "interchange1"
    t.integer "interchange2"
    t.integer "air"
    t.integer "arrive"
    t.integer "leave"
  end

  create_table "expresses", force: :cascade do |t|
    t.string "express_no"
    t.integer "business_id"
    t.integer "post_unit_id"
    t.datetime "posting_date"
    t.integer "last_unit_id"
    t.string "status"
    t.datetime "last_op_at"
    t.string "last_op_desc"
    t.string "sign"
    t.string "desc"
    t.float "delivered_days"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "last_unit_no"
    t.string "post_unit_no"
    t.string "receiver_province_no"
    t.string "receiver_district"
    t.string "last_unit_name"
    t.string "whereis"
    t.string "base_product_no"
    t.string "receipt_flag"
    t.string "receipt_status"
    t.string "pre_waybill_no"
    t.integer "pre_express_id"
    t.string "receipt_waybill_no"
    t.integer "receipt_express_id"
    t.string "receiver_city_no"
    t.string "receiver_county_no"
    t.string "receiver_district_no"
    t.integer "posting_hour"
    t.string "distributive_center_no"
    t.string "delivered_status"
    t.string "biz_product_no"
    t.string "transfer_type"
    t.integer "delivered_hour"
    t.string "last_prov"
    t.string "last_city"
    t.boolean "is_change_addr"
    t.boolean "is_cancelled"
    t.decimal "postage_total"
    t.index ["business_id"], name: "index_expresses_on_business_id"
    t.index ["delivered_days"], name: "index_expresses_on_delivered_days"
    t.index ["delivered_status"], name: "index_expresses_on_delivered_status"
    t.index ["express_no"], name: "index_expresses_on_express_no"
    t.index ["last_unit_id"], name: "index_expresses_on_last_unit_id"
    t.index ["post_unit_id"], name: "index_expresses_on_post_unit_id"
    t.index ["posting_date"], name: "index_expresses_on_posting_date"
    t.index ["status"], name: "index_expresses_on_status"
    t.index ["whereis"], name: "index_expresses_on_whereis"
  end

  create_table "import_files", force: :cascade do |t|
    t.string "file_name", null: false
    t.string "file_path", default: "", null: false
    t.integer "user_id"
    t.integer "unit_id"
    t.integer "country_id"
    t.string "batch_no"
    t.string "status"
    t.string "desc"
    t.string "err_file_path"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "international_expresses", force: :cascade do |t|
    t.string "express_no"
    t.integer "country_id"
    t.integer "business_id"
    t.datetime "posting_date"
    t.string "receiver_postcode"
    t.float "weight"
    t.integer "receiver_zone_id"
    t.integer "import_file_id"
    t.string "status"
    t.boolean "is_arrived"
    t.datetime "arrived_at"
    t.integer "arrived_hours"
    t.boolean "is_leaved"
    t.datetime "leaved_at"
    t.integer "leaved_hours"
    t.boolean "is_leaved_orig"
    t.datetime "leaved_orig_at"
    t.boolean "leaved_orig_after_18"
    t.boolean "is_leaved_center"
    t.datetime "leaved_center_at"
    t.integer "leaved_center_hours"
    t.boolean "is_takeoff"
    t.datetime "takeoff_at"
    t.integer "takeoff_hours"
    t.datetime "last_op_at"
    t.string "last_op_desc"
    t.string "last_unit_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["business_id"], name: "index_international_expresses_on_business_id"
    t.index ["country_id"], name: "index_international_expresses_on_country_id"
    t.index ["is_leaved_center"], name: "index_international_expresses_on_is_leaved_center"
    t.index ["receiver_zone_id"], name: "index_international_expresses_on_receiver_zone_id"
    t.index ["status"], name: "index_international_expresses_on_status"
  end

  create_table "messages", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "roles"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "receiver_zones", force: :cascade do |t|
    t.string "zone", null: false
    t.integer "country_id", null: false
    t.string "start_postcode", null: false
    t.string "end_postcode", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.integer "user_id"
    t.integer "unit_id"
    t.string "role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "units", force: :cascade do |t|
    t.string "name"
    t.string "desc"
    t.string "no"
    t.string "short_name"
    t.integer "level"
    t.integer "parent_id"
    t.string "unit_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_units_on_name", unique: true
  end

  create_table "up_downloads", force: :cascade do |t|
    t.string "name"
    t.string "use"
    t.string "desc"
    t.string "ver_no"
    t.string "url"
    t.datetime "oper_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_logs", force: :cascade do |t|
    t.integer "user_id", default: 0, null: false
    t.string "operation", default: "", null: false
    t.string "object_class"
    t.integer "object_primary_key"
    t.string "object_symbol"
    t.string "desc"
    t.integer "parent_id"
    t.string "parent_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_messages", force: :cascade do |t|
    t.integer "message_id"
    t.integer "user_id"
    t.boolean "is_read", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "username", default: "", null: false
    t.string "role", default: "", null: false
    t.string "name"
    t.string "status"
    t.integer "unit_id"
    t.datetime "locked_at"
    t.integer "failed_attempts", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
