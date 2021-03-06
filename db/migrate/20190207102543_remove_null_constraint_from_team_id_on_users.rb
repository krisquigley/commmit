# frozen_string_literal: true

class RemoveNullConstraintFromTeamIdOnUsers < ActiveRecord::Migration[5.2]
  def change
    change_column_null :users, :team_id, true
  end
end
