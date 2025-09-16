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

ActiveRecord::Schema[7.1].define(version: 2025_09_16_162450) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "expenses", force: :cascade do |t|
    t.string "description", limit: 80, null: false
    t.date "date", null: false
    t.decimal "amount", null: false
    t.string "location", limit: 50, null: false
    t.string "status", limit: 1, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "expenses_tags", id: false, force: :cascade do |t|
    t.bigint "expense_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_id", "tag_id"], name: "index_expenses_tags_on_expense_id_and_tag_id"
    t.index ["tag_id", "expense_id"], name: "index_expenses_tags_on_tag_id_and_expense_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "description", limit: 20, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", limit: 60, default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "role", null: false
    t.integer "manager_user_id"
    t.string "active", default: "true", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["manager_user_id"], name: "index_users_on_manager_user_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.check_constraint "role::text = 'E'::text AND manager_user_id IS NOT NULL OR role::text = 'M'::text AND manager_user_id IS NULL", name: "role_manager_check"
  end

  add_foreign_key "expenses", "users"
  add_foreign_key "users", "users", column: "manager_user_id"
end
