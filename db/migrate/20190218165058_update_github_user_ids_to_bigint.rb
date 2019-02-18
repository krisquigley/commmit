class UpdateGithubUserIdsToBigint < ActiveRecord::Migration[5.2]
  def change
    change_column :sprint_tickets, :github_user_ids, :bigint, default: [], array: true
  end
end
