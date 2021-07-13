# frozen_string_literal: true

class AddStoryIdToCommmits < ActiveRecord::Migration[6.1]
  def change
    add_column :commmits, :goal_id, :bigint
    add_index :commmits, :goal_id
    change_column_null :commmits, :name, true
  end
end
