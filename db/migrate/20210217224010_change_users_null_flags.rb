# frozen_string_literal: true

class ChangeUsersNullFlags < ActiveRecord::Migration[6.1]
  def change
    change_column_null :users, :github_user_id, true
    change_column_null :users, :source, true
    change_column_null :users, :name, true

    remove_index :users, :github_user_id
    add_index :users, :github_user_id
  end
end
