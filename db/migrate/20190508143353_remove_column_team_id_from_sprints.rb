class RemoveColumnTeamIdFromSprints < ActiveRecord::Migration[5.2]
  def change
    remove_column :sprints, :team_id, :integer
  end
end
