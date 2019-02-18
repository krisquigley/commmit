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

ActiveRecord::Schema.define(version: 2019_02_18_165058) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "sprint_holidays", force: :cascade do |t|
    t.integer "sprint_id", null: false
    t.integer "user_id", null: false
    t.integer "days", default: 0, null: false
    t.index ["sprint_id"], name: "index_sprint_holidays_on_sprint_id"
    t.index ["user_id"], name: "index_sprint_holidays_on_user_id"
  end

  create_table "sprint_tickets", force: :cascade do |t|
    t.string "title", null: false
    t.bigint "issue_id", null: false
    t.string "repository_name", null: false
    t.bigint "github_user_ids", default: [], array: true
    t.integer "number", null: false
    t.string "state", null: false
    t.integer "estimated_effort", null: false
    t.integer "actual_effort"
    t.datetime "closed_at"
    t.integer "sprint_id"
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notes"
    t.index ["github_user_ids"], name: "index_sprint_tickets_on_github_user_ids"
    t.index ["sprint_id"], name: "index_sprint_tickets_on_sprint_id"
  end

  create_table "sprints", force: :cascade do |t|
    t.integer "team_id", null: false
    t.string "name", null: false
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "available_effort", null: false
    t.index ["team_id"], name: "index_sprints_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.string "title", null: false
    t.integer "estimated_effort", null: false
    t.datetime "closed_at"
    t.integer "sprint_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "issue_id", null: false
    t.string "repository_name", null: false
    t.integer "number", null: false
    t.string "state", null: false
    t.bigint "github_user_ids", default: [], array: true
    t.string "url", null: false
    t.jsonb "source", null: false
    t.index ["issue_id"], name: "index_tickets_on_issue_id", unique: true
    t.index ["sprint_id"], name: "index_tickets_on_sprint_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.integer "team_id"
    t.bigint "github_user_id", null: false
    t.jsonb "source", null: false
    t.index ["github_user_id"], name: "index_users_on_github_user_id", unique: true
    t.index ["team_id"], name: "index_users_on_team_id"
  end

end
