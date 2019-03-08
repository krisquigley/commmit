class AddEffortAdjustmentToSprints < ActiveRecord::Migration[5.2]
  def change
    add_column :sprints, :effort_adjustment, :integer
  end
end
