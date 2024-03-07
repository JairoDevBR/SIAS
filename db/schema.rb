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

ActiveRecord::Schema[7.1].define(version: 2024_03_06_214826) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "emergencies", force: :cascade do |t|
    t.integer "gravity"
    t.datetime "time_start"
    t.datetime "time_end"
    t.integer "n_people"
    t.integer "category"
    t.float "start_lon"
    t.float "start_lat"
    t.float "end_lon"
    t.float "end_lat"
    t.text "description"
    t.string "street"
    t.string "neighborhood"
    t.string "city"
    t.bigint "user_id", null: false
    t.bigint "schedule_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["schedule_id"], name: "index_emergencies_on_schedule_id"
    t.index ["user_id"], name: "index_emergencies_on_user_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "worker1_id", null: false
    t.bigint "worker2_id", null: false
    t.bigint "user_id", null: false
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_schedules_on_user_id"
    t.index ["worker1_id"], name: "index_schedules_on_worker1_id"
    t.index ["worker2_id"], name: "index_schedules_on_worker2_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
    t.boolean "central"
    t.integer "kind"
    t.string "plate"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workers", force: :cascade do |t|
    t.string "name"
    t.integer "occupation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "emergencies", "schedules"
  add_foreign_key "emergencies", "users"
  add_foreign_key "schedules", "users"
  add_foreign_key "schedules", "workers", column: "worker1_id"
  add_foreign_key "schedules", "workers", column: "worker2_id"
end
