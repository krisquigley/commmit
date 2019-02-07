class AddGithubUserIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :github_user_id, :bigint, null: false
  end
end
