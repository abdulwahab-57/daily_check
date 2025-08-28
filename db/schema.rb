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

ActiveRecord::Schema[7.2].define(version: 2025_08_28_141541) do
  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug", null: false
    t.text "description"
    t.integer "status", default: 1, null: false
    t.date "start_date"
    t.date "due_date"
    t.integer "todos_count", default: 0, null: false
    t.integer "completed_todos_count", default: 0, null: false
    t.index ["slug"], name: "index_projects_on_slug", unique: true
  end

  create_table "todos", force: :cascade do |t|
    t.string "title"
    t.integer "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.integer "status", default: 0, null: false
    t.integer "priority", default: 1, null: false
    t.date "due_date"
    t.datetime "starts_at"
    t.datetime "completed_at"
    t.integer "estimate_minutes", default: 0, null: false
    t.integer "time_spent_minutes", default: 0, null: false
    t.integer "parent_id"
    t.index ["due_date"], name: "index_todos_on_due_date"
    t.index ["parent_id"], name: "index_todos_on_parent_id"
    t.index ["project_id"], name: "index_todos_on_project_id"
    t.index ["status"], name: "index_todos_on_status"
  end

  add_foreign_key "todos", "projects"
  add_foreign_key "todos", "todos", column: "parent_id"
end
