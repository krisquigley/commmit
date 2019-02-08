class ChangeColumnGithubUserIdsToArray < ActiveRecord::Migration[5.2]
  def up
    remove_column :tickets, :github_user_ids
    add_column :tickets, :github_user_ids, :integer, limit: 8, array: true, default: []
  end

  def down
    change_column :tickets, :github_user_ids, :bigint
  end
end
