# frozen_string_literal: true

class CreateStories < ActiveRecord::Migration[6.1]
  def change
    create_table :stories do |t|
      t.string :goal, null: false
      t.string :reason
      t.string :slug
      t.text :notes
      t.bigint :mvt_id
      t.bigint :lvt_id
      t.datetime :completed_at

      t.belongs_to :account
      t.timestamps
    end

    create_table :planned_stories do |t|
      t.belongs_to :account
      t.belongs_to :commmit
      t.belongs_to :story
      t.datetime :completed_at

      t.timestamps
    end

    add_index :stories, :goal
    add_index :stories, :mvt_id
    add_index :stories, :lvt_id
    add_index :stories, :completed_at
    add_index :stories, :created_at
    add_index :commmits, :created_at
    add_index :planned_stories, :created_at
  end
end

# How can I give the people I meet, the confidence to speak up for themselves?
