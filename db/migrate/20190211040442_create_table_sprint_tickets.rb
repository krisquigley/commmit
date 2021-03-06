# frozen_string_literal: true

class CreateTableSprintTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :sprint_tickets do |t|
      t.string :title, null: false
      t.bigint :issue_id, null: false
      t.string :repository_name, null: false
      t.integer :github_user_ids, default: [], array: true
      t.integer :number, null: false
      t.string :state, null: false
      t.integer :estimated_effort, null: false
      t.integer :actual_effort
      t.datetime :closed_at
      t.integer :sprint_id
      t.string :url, null: false
      t.timestamps
    end

    add_index :sprint_tickets, :sprint_id
    add_index :sprint_tickets, :github_user_ids
  end
end
