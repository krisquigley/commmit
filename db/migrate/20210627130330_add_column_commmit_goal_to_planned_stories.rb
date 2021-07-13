# frozen_string_literal: true

class AddColumnCommmitGoalToPlannedStories < ActiveRecord::Migration[6.1]
  def change
    add_column :planned_stories, :commmit_goal, :boolean, default: false, null: false
    add_index :planned_stories, :commmit_goal
  end
end
