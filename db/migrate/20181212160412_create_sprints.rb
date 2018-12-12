class CreateSprints < ActiveRecord::Migration[5.2]
  def change
    create_table :sprints do |t|
      t.integer :team_id, null: false
      t.string :name, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.timestamps
    end

    add_index :sprints, :team_id
  end
end
