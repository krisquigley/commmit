# frozen_string_literal: true

class MakeGithubIdColumnsUnique < ActiveRecord::Migration[5.2]
  def change
    remove_index :tickets, :issue_id
    add_index :tickets, :issue_id, unique: true
    add_index :users, :github_user_id, unique: true
  end
end
