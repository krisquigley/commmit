class RenameActualEffortToEffortSpent < ActiveRecord::Migration[5.2]
  def change
    rename_column :sprint_tickets, :actual_effort, :effort_spent
  end
end
