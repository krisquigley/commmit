# frozen_string_literal: true

class AddColumnGithubUserIdAndRemoveUserId < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :github_user_ids, :bigint
    add_index :tickets, :github_user_ids
    remove_index :tickets, :user_id
    remove_column :tickets, :user_id, :integer
  end
end
