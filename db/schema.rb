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

ActiveRecord::Schema.define(version: 2019_05_08_143353) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "sprint_holidays", force: :cascade do |t|
    t.integer "sprint_id", null: false
    t.integer "user_id", null: false
    t.decimal "days", default: "0.0", null: false
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
    t.decimal "estimated_effort", null: false
    t.decimal "effort_spent"
    t.datetime "closed_at"
    t.integer "sprint_id"
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notes"
    t.decimal "estimated_effort_override"
    t.integer "position"
    t.index ["github_user_ids"], name: "index_sprint_tickets_on_github_user_ids"
    t.index ["position"], name: "index_sprint_tickets_on_position"
    t.index ["sprint_id"], name: "index_sprint_tickets_on_sprint_id"
  end

  create_table "sprints", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "available_effort"
    t.datetime "closed_at"
    t.integer "effort_adjustment"
    t.string "slug"
    t.index ["closed_at"], name: "index_sprints_on_closed_at"
    t.index ["slug"], name: "index_sprints_on_slug", unique: true
  end

  create_table "sprints_users", id: false, force: :cascade do |t|
    t.bigint "sprint_id"
    t.bigint "user_id"
    t.index ["sprint_id"], name: "index_sprints_users_on_sprint_id"
    t.index ["user_id"], name: "index_sprints_users_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.string "title", null: false
    t.decimal "estimated_effort", null: false
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
    t.index ["repository_name"], name: "index_tickets_on_repository_name"
    t.index ["sprint_id"], name: "index_tickets_on_sprint_id"
    t.index ["title"], name: "index_tickets_on_title"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.integer "team_id"
    t.bigint "github_user_id", null: false
    t.jsonb "source", null: false
    t.string "slug"
    t.index ["github_user_id"], name: "index_users_on_github_user_id", unique: true
    t.index ["team_id"], name: "index_users_on_team_id"
  end

end
