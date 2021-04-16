# frozen_string_literal: true

class CreateTags < ActiveRecord::Migration[6.1]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :color, null: false
      t.belongs_to :account

      t.timestamps
    end

    create_table :commmits_tags, id: false do |t|
      t.belongs_to :commmit
      t.belongs_to :tag
    end

    create_table :stories_tags, id: false do |t|
      t.belongs_to :story
      t.belongs_to :tag
    end

    make_slugs_null

    remove_indexs

    add_index :accounts, :slug, unique: true
    add_index :commmits, %i[slug account_id], unique: true
    add_index :tags, %i[slug account_id], unique: true
    add_index :teams, %i[slug account_id], unique: true
    add_index :users, :slug, unique: true
  end

  def make_slugs_null
    change_column_null :accounts, :slug, false
    change_column_null :commmits, :slug, false
    change_column_null :stories, :slug, false
    change_column_null :teams, :slug, false
    change_column_null :users, :slug, false
  end

  def remove_indexs
    remove_index :accounts, :slug
    remove_index :commmits, :slug
    remove_index :teams, :slug
  end
end
