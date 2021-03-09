# frozen_string_literal: true

class CreateStories < ActiveRecord::Migration[6.1]
  def change
    create_table :stories do |t|
      t.string :i_want, null: false
      t.string :so_that
      t.string :slug
      t.text :notes
      t.bigint :mvt_id
      t.bigint :lvt_id
      t.datetime :completed_at

      t.belongs_to :account
      t.belongs_to :commmit
      t.timestamps
    end

    add_index :stories, :i_want
    add_index :stories, :mvt_id
    add_index :stories, :lvt_id
  end
end

# How can I give the people I meet, the confidence to speak up for themselves?
