# frozen_string_literal: true

class ConvertEffortValuesToDecimals < ActiveRecord::Migration[5.2]
  def up
    change_column :sprint_tickets, :estimated_effort, :decimal, null: false
    change_column :sprint_tickets, :actual_effort, :decimal
    change_column :sprints, :available_effort, :decimal, null: false
    change_column :tickets, :estimated_effort, :decimal
    change_column :sprint_holidays, :days, :decimal, null: false, default: 0
  end

  def down
    change_column :sprint_tickets, :estimated_effort, :integer, null: false
    change_column :sprint_tickets, :actual_effort, :integer
    change_column :sprints, :available_effort, :integer, null: false
    change_column :tickets, :estimated_effort, :integer
    change_column :sprint_holidays, :days, :integer, null: false, default: 0
  end
end
