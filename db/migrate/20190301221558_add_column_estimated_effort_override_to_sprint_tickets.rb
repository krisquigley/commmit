# frozen_string_literal: true

class AddColumnEstimatedEffortOverrideToSprintTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :sprint_tickets, :estimated_effort_override, :decimal
  end
end
