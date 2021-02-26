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

ActiveRecord::Schema.define(version: 2021_02_17_224010) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.string "subdomain", null: false
    t.bigint "owner_user_id"
    t.string "account_type", default: "personal", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_user_id", "account_type"], name: "index_accounts_on_owner_user_id_and_account_type"
    t.index ["owner_user_id"], name: "index_accounts_on_owner_user_id"
    t.index ["subdomain"], name: "index_accounts_on_subdomain", unique: true
  end

  create_table "accounts_users", id: false, force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "user_id"
    t.index ["account_id"], name: "index_accounts_users_on_account_id"
    t.index ["user_id"], name: "index_accounts_users_on_user_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.bigint "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "retrospectives", force: :cascade do |t|
    t.bigint "sprint_id", null: false
    t.bigint "user_id"
    t.float "role_happiness", null: false
    t.float "team_happiness"
    t.float "company_happiness", null: false
    t.string "feedback", null: false
    t.string "happiness_goal", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "average_happiness"
    t.bigint "account_id", null: false
    t.index ["account_id"], name: "index_retrospectives_on_account_id"
    t.index ["sprint_id"], name: "index_retrospectives_on_sprint_id"
    t.index ["user_id"], name: "index_retrospectives_on_user_id"
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
    t.bigint "sprint_id"
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notes"
    t.decimal "estimated_effort_override"
    t.integer "position"
    t.boolean "kaizen"
    t.jsonb "source"
    t.datetime "assigned_at"
    t.bigint "account_id", null: false
    t.index ["account_id"], name: "index_sprint_tickets_on_account_id"
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
    t.string "slug"
    t.text "what_went_well"
    t.text "what_could_be_better"
    t.text "what_one_thing_to_work_on"
    t.integer "team_id"
    t.decimal "final_velocity"
    t.integer "no_of_members"
    t.decimal "days_off", default: "0.0"
    t.datetime "finish_by"
    t.bigint "initial_ticket_ids", default: [], array: true
    t.bigint "account_id", null: false
    t.index ["account_id"], name: "index_sprints_on_account_id"
    t.index ["closed_at"], name: "index_sprints_on_closed_at"
    t.index ["initial_ticket_ids"], name: "index_sprints_on_initial_ticket_ids"
    t.index ["slug"], name: "index_sprints_on_slug", unique: true
    t.index ["team_id"], name: "index_sprints_on_team_id"
  end

  create_table "sprints_users", id: false, force: :cascade do |t|
    t.bigint "sprint_id"
    t.bigint "user_id"
    t.index ["sprint_id"], name: "index_sprints_users_on_sprint_id"
    t.index ["user_id"], name: "index_sprints_users_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug"
    t.bigint "account_id", null: false
    t.index ["account_id"], name: "index_teams_on_account_id"
    t.index ["slug"], name: "index_teams_on_slug"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "title", null: false
    t.decimal "estimated_effort", null: false
    t.datetime "closed_at"
    t.bigint "sprint_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "issue_id", null: false
    t.string "repository_name", null: false
    t.integer "number", null: false
    t.string "state", null: false
    t.bigint "github_user_ids", default: [], array: true
    t.string "url", null: false
    t.jsonb "source", null: false
    t.datetime "assigned_at"
    t.bigint "account_id", null: false
    t.index ["account_id"], name: "index_tickets_on_account_id"
    t.index ["assigned_at"], name: "index_tickets_on_assigned_at"
    t.index ["closed_at"], name: "index_tickets_on_closed_at"
    t.index ["issue_id"], name: "index_tickets_on_issue_id", unique: true
    t.index ["number"], name: "index_tickets_on_number"
    t.index ["repository_name"], name: "index_tickets_on_repository_name"
    t.index ["sprint_id"], name: "index_tickets_on_sprint_id"
    t.index ["title"], name: "index_tickets_on_title"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.bigint "team_id"
    t.bigint "github_user_id"
    t.jsonb "source"
    t.string "slug"
    t.string "username", null: false
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["github_user_id"], name: "index_users_on_github_user_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["team_id"], name: "index_users_on_team_id"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
