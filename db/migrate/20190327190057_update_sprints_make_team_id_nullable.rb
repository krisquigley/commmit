class UpdateSprintsMakeTeamIdNullable < ActiveRecord::Migration[5.2]
  def change
    change_column_null :sprints, :team_id, true
    change_column_null :sprints, :available_effort, true
  end
end
