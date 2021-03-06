# frozen_string_literal: true

class RemoveColumnEffortAdjustment < ActiveRecord::Migration[5.2]
  def change
    remove_column :sprints, :effort_adjustment, :integer
  end
end
