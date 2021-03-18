# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_210_318_171_125) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'pgcrypto'
  enable_extension 'plpgsql'

  create_table 'accounts', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'subdomain', null: false
    t.bigint 'owner_user_id'
    t.string 'account_type', default: 'personal', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.string 'slug', null: false
    t.index %w[owner_user_id account_type],
            name: 'index_accounts_on_owner_user_id_and_account_type'
    t.index ['owner_user_id'], name: 'index_accounts_on_owner_user_id'
    t.index ['slug'], name: 'index_accounts_on_slug', unique: true
    t.index ['subdomain'], name: 'index_accounts_on_subdomain', unique: true
  end

  create_table 'accounts_users', id: false, force: :cascade do |t|
    t.bigint 'account_id'
    t.bigint 'user_id'
    t.index ['account_id'], name: 'index_accounts_users_on_account_id'
    t.index ['user_id'], name: 'index_accounts_users_on_user_id'
  end

  create_table 'commmits', force: :cascade do |t|
    t.string 'name', null: false
    t.integer 'length_in_days', default: 1, null: false
    t.string 'slug', null: false
    t.date 'start_date', default: -> { 'CURRENT_DATE' }, null: false
    t.bigint 'account_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.integer 'commmit_stories_count'
    t.index ['account_id'], name: 'index_commmits_on_account_id'
    t.index ['created_at'], name: 'index_commmits_on_created_at'
    t.index %w[slug account_id], name: 'index_commmits_on_slug_and_account_id', unique: true
    t.index ['start_date'], name: 'index_commmits_on_start_date'
  end

  create_table 'commmits_tags', id: false, force: :cascade do |t|
    t.bigint 'commmit_id'
    t.bigint 'tag_id'
    t.index ['commmit_id'], name: 'index_commmits_tags_on_commmit_id'
    t.index ['tag_id'], name: 'index_commmits_tags_on_tag_id'
  end

  create_table 'friendly_id_slugs', force: :cascade do |t|
    t.string 'slug', null: false
    t.bigint 'sluggable_id', null: false
    t.string 'sluggable_type', limit: 50
    t.string 'scope'
    t.datetime 'created_at'
    t.index %w[slug sluggable_type scope],
            name: 'index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope', unique: true
    t.index %w[slug sluggable_type], name: 'index_friendly_id_slugs_on_slug_and_sluggable_type'
    t.index %w[sluggable_type sluggable_id],
            name: 'index_friendly_id_slugs_on_sluggable_type_and_sluggable_id'
  end

  create_table 'planned_stories', force: :cascade do |t|
    t.bigint 'account_id'
    t.bigint 'commmit_id'
    t.bigint 'story_id'
    t.datetime 'completed_at'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['account_id'], name: 'index_planned_stories_on_account_id'
    t.index ['commmit_id'], name: 'index_planned_stories_on_commmit_id'
    t.index ['created_at'], name: 'index_planned_stories_on_created_at'
    t.index ['story_id'], name: 'index_planned_stories_on_story_id'
  end

  create_table 'stories', force: :cascade do |t|
    t.string 'goal', null: false
    t.string 'reason'
    t.string 'slug', null: false
    t.text 'notes'
    t.bigint 'mvt_id'
    t.bigint 'lvt_id'
    t.datetime 'completed_at'
    t.bigint 'account_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.boolean 'repeatable', default: false
    t.index ['account_id'], name: 'index_stories_on_account_id'
    t.index ['completed_at'], name: 'index_stories_on_completed_at'
    t.index ['created_at'], name: 'index_stories_on_created_at'
    t.index ['goal'], name: 'index_stories_on_goal'
    t.index ['lvt_id'], name: 'index_stories_on_lvt_id'
    t.index ['mvt_id'], name: 'index_stories_on_mvt_id'
  end

  create_table 'stories_tags', id: false, force: :cascade do |t|
    t.bigint 'story_id'
    t.bigint 'tag_id'
    t.index ['story_id'], name: 'index_stories_tags_on_story_id'
    t.index ['tag_id'], name: 'index_stories_tags_on_tag_id'
  end

  create_table 'tags', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'slug', null: false
    t.string 'color', null: false
    t.bigint 'account_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['account_id'], name: 'index_tags_on_account_id'
    t.index %w[slug account_id], name: 'index_tags_on_slug_and_account_id', unique: true
  end

  create_table 'teams', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'slug', null: false
    t.bigint 'account_id', null: false
    t.index ['account_id'], name: 'index_teams_on_account_id'
    t.index %w[slug account_id], name: 'index_teams_on_slug_and_account_id', unique: true
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name'
    t.bigint 'team_id'
    t.bigint 'github_user_id'
    t.jsonb 'source'
    t.string 'slug', null: false
    t.string 'username', null: false
    t.string 'email', null: false
    t.string 'encrypted_password', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer 'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.string 'current_sign_in_ip'
    t.string 'last_sign_in_ip'
    t.string 'confirmation_token'
    t.datetime 'confirmed_at'
    t.datetime 'confirmation_sent_at'
    t.string 'unconfirmed_email'
    t.integer 'failed_attempts', default: 0, null: false
    t.string 'unlock_token'
    t.datetime 'locked_at'
    t.index ['confirmation_token'], name: 'index_users_on_confirmation_token', unique: true
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['github_user_id'], name: 'index_users_on_github_user_id'
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
    t.index ['slug'], name: 'index_users_on_slug', unique: true
    t.index ['team_id'], name: 'index_users_on_team_id'
    t.index ['unlock_token'], name: 'index_users_on_unlock_token', unique: true
    t.index ['username'], name: 'index_users_on_username', unique: true
  end
end
