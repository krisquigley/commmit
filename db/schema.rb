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

ActiveRecord::Schema.define(version: 2018_12_12_161950) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.integer "user_id"
    t.integer "estimated_effort", null: false
    t.integer "actual_effort"
    t.datetime "date_merged"
    t.integer "sprint_id"
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sprint_id"], name: "index_tickets_on_sprint_id"
    t.index ["user_id"], name: "index_tickets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.integer "team_id", null: false
    t.index ["team_id"], name: "index_users_on_team_id"
  end

end
