# frozen_string_literal: true

class AddColumnTeamIdToSprints < ActiveRecord::Migration[5.2]
  def change
    add_column :sprints, :team_id, :integer
    add_index :sprints, :team_id
  end
end
