class AddGoalIdToCommmits < ActiveRecord::Migration[6.1]
  def change
    add_column :commmits, :story_id, :bigint
    add_index :commmits, :story_id
  end
end
