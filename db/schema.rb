# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160521080114) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: true do |t|
    t.string   "company_title", limit: 400
    t.integer  "out_id",        limit: 8
    t.string   "inn",           limit: 25
    t.string   "short_title",   limit: 100
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "construction_objects", force: true do |t|
    t.integer  "out_id",                     limit: 8
    t.string   "object_name",                limit: nil
    t.string   "podotrasl",                  limit: nil
    t.string   "seria",                      limit: nil
    t.string   "prefektura",                 limit: nil
    t.float    "latitude"
    t.float    "longitude"
    t.float    "total_space"
    t.float    "living_space"
    t.float    "total_places"
    t.float    "car_places"
    t.float    "road_length"
    t.integer  "floor_count"
    t.integer  "one_room_count"
    t.integer  "two_room_count"
    t.integer  "three_room_count"
    t.integer  "four_room_count"
    t.string   "is_there_a_wreckage",        limit: nil
    t.date     "planning_comissioning_date"
    t.float    "cost_limit"
    t.float    "current_year_limit"
    t.date     "techincal_state_date"
    t.string   "technical_state",            limit: nil
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "podotrasl_id"
    t.integer  "prefektura_id"
    t.string   "otrasl_name",                limit: nil
    t.integer  "otrasl_id"
    t.string   "code_ds",                    limit: 100
    t.boolean  "is_active"
  end

  create_table "department_groups", force: true do |t|
    t.string  "name"
    t.integer "order"
  end

  create_table "document_types", force: true do |t|
    t.string   "doc_type",   limit: nil
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "documents", force: true do |t|
    t.integer  "out_id",                     limit: 8
    t.string   "doc_type",                   limit: nil
    t.integer  "doc_type_id",                limit: 8
    t.string   "doc_number",                 limit: nil
    t.date     "doc_date"
    t.string   "doc_status",                 limit: nil
    t.integer  "doc_status_id",              limit: 8
    t.date     "doc_term"
    t.integer  "construction_object_out_id", limit: 8
    t.integer  "construction_object_id",     limit: 8
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "employee_stats_departments", force: true do |t|
    t.date     "month"
    t.integer  "department_id"
    t.float    "salary"
    t.float    "bonus"
    t.float    "tax"
    t.float    "avg_salary"
    t.string   "manager",             limit: 500
    t.string   "dep_type",            limit: 2,   default: "p"
    t.string   "dep_name",            limit: 500
    t.integer  "employee_count"
    t.integer  "vacancy_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "department_group_id"
  end

  create_table "employee_stats_months", force: true do |t|
    t.date     "month"
    t.float    "salary"
    t.float    "bonus"
    t.float    "tax"
    t.float    "avg_salary"
    t.float    "salary_manage"
    t.float    "bonus_manage"
    t.float    "tax_manage"
    t.float    "avg_salary_manage"
    t.integer  "employee_count"
    t.integer  "employee_adds"
    t.integer  "employee_dismiss"
    t.integer  "vacancy_count"
    t.integer  "employee_manage_count"
    t.integer  "employee_production_count"
    t.float    "k_dismiss"
    t.float    "k_complect"
    t.float    "manager_avg_salary"
    t.integer  "AUP_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "engeneering_network_links", force: true do |t|
    t.integer  "object_out_id", limit: 8
    t.integer  "network_id"
    t.float    "percentage"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "external_engeneering_networks", force: true do |t|
    t.string   "network_name",  limit: nil
    t.string   "network_alias", limit: nil
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "imported_photos", force: true do |t|
    t.integer "photo_out_id"
    t.integer "obj_id"
    t.date    "photo_date"
    t.string  "url"
  end

  create_table "otrasls", force: true do |t|
    t.string   "otrasl_name", limit: nil
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "podotrasls", force: true do |t|
    t.string   "podotrasl_name", limit: nil
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "prefekturas", force: true do |t|
    t.string   "prefektura_name", limit: nil
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "task_types", force: true do |t|
    t.string   "task_type",  limit: nil
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "tasks", force: true do |t|
    t.integer  "out_id",       limit: 8
    t.string   "task_name",    limit: nil
    t.integer  "task_type"
    t.date     "task_plan"
    t.date     "task_fact"
    t.integer  "group_type"
    t.integer  "object_id",    limit: 8
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "task_type_id", limit: 8
  end

  create_table "trades", force: true do |t|
    t.integer  "out_id",             limit: 8
    t.string   "contract_number",    limit: nil
    t.string   "trade_status",       limit: nil
    t.float    "starting_price"
    t.string   "winner",             limit: nil
    t.float    "winners_price"
    t.date     "trade_date"
    t.string   "trade_type",         limit: nil
    t.integer  "lot_id",             limit: 8
    t.integer  "object_id",          limit: 8
    t.integer  "participants_count"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "company_id"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  limit: nil, default: "", null: false
    t.string   "encrypted_password",     limit: nil, default: "", null: false
    t.string   "reset_password_token",   limit: nil
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: nil
    t.string   "last_sign_in_ip",        limit: nil
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.string   "authentication_token",   limit: 30
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
