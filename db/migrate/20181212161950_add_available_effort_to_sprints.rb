class AddAvailableEffortToSprints < ActiveRecord::Migration[5.2]
  def change
    add_column :sprints, :available_effort, :integer, null: false
  end
end
