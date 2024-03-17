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

ActiveRecord::Schema[7.1].define(version: 2024_03_17_012412) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blazer_audits", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "query_id"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at"
    t.index ["query_id"], name: "index_blazer_audits_on_query_id"
    t.index ["user_id"], name: "index_blazer_audits_on_user_id"
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.bigint "creator_id"
    t.bigint "query_id"
    t.string "state"
    t.string "schedule"
    t.text "emails"
    t.text "slack_channels"
    t.string "check_type"
    t.text "message"
    t.datetime "last_run_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_checks_on_creator_id"
    t.index ["query_id"], name: "index_blazer_checks_on_query_id"
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.bigint "dashboard_id"
    t.bigint "query_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dashboard_id"], name: "index_blazer_dashboard_queries_on_dashboard_id"
    t.index ["query_id"], name: "index_blazer_dashboard_queries_on_query_id"
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_dashboards_on_creator_id"
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.text "description"
    t.text "statement"
    t.string "data_source"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_queries_on_creator_id"
  end

  create_table "chatrooms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chats", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "emergencies", force: :cascade do |t|
    t.integer "gravity"
    t.datetime "time_start"
    t.datetime "time_end"
    t.integer "n_people"
    t.integer "category"
    t.float "start_lon"
    t.float "start_lat"
    t.float "emergency_lon"
    t.float "emergency_lat"
    t.float "end_lon"
    t.float "end_lat"
    t.string "local_type"
    t.text "description"
    t.string "street"
    t.string "neighborhood"
    t.string "city"
    t.bigint "user_id", null: false
    t.bigint "schedule_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "hospital_id"
    t.index ["hospital_id"], name: "index_emergencies_on_hospital_id"
    t.index ["schedule_id"], name: "index_emergencies_on_schedule_id"
    t.index ["user_id"], name: "index_emergencies_on_user_id"
  end

  create_table "hospitals", force: :cascade do |t|
    t.string "name"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.string "content"
    t.bigint "chatroom_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chatroom_id"], name: "index_messages_on_chatroom_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "gender"
    t.integer "age"
    t.integer "heart_rate"
    t.integer "blood_pressure"
    t.integer "respiratory_rate"
    t.integer "oxygen_saturation"
    t.integer "consciousness"
    t.integer "pain"
    t.integer "gravity"
    t.text "medical_history"
    t.text "description"
    t.bigint "emergency_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["emergency_id"], name: "index_patients_on_emergency_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "content"
    t.bigint "chat_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_posts_on_chat_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "worker1_id", null: false
    t.bigint "worker2_id", null: false
    t.bigint "user_id", null: false
    t.boolean "active"
    t.float "current_lon"
    t.float "current_lat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_schedules_on_user_id"
    t.index ["worker1_id"], name: "index_schedules_on_worker1_id"
    t.index ["worker2_id"], name: "index_schedules_on_worker2_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.integer "tesoura"
    t.integer "luvas"
    t.integer "pinça"
    t.integer "esparadrapo"
    t.integer "alcool"
    t.integer "gaze_esterilizada"
    t.integer "atadura"
    t.integer "bandagens"
    t.integer "medicamentos_basicos"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_stocks_on_user_id"
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
    t.boolean "hospital"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workers", force: :cascade do |t|
    t.string "name"
    t.integer "occupation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "emergencies", "hospitals"
  add_foreign_key "emergencies", "schedules"
  add_foreign_key "emergencies", "users"
  add_foreign_key "messages", "chatrooms"
  add_foreign_key "messages", "users"
  add_foreign_key "patients", "emergencies"
  add_foreign_key "posts", "chats"
  add_foreign_key "posts", "users"
  add_foreign_key "schedules", "users"
  add_foreign_key "schedules", "workers", column: "worker1_id"
  add_foreign_key "schedules", "workers", column: "worker2_id"
  add_foreign_key "stocks", "users"
end
