class AddColumnsRetroToSprints < ActiveRecord::Migration[5.2]
  def change
    add_column :sprints, :what_went_well, :text
    add_column :sprints, :what_could_be_better, :text
    add_column :sprints, :what_one_thing_to_work_on, :text
  end
end
