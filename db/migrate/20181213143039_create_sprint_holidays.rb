class CreateSprintHolidays < ActiveRecord::Migration[5.2]
  def change
    create_table :sprint_holidays do |t|
      t.integer :sprint_id, null: false
      t.integer :user_id, null: false
      t.integer :days, null: false, default: 0
    end

    add_index :sprint_holidays, :sprint_id
    add_index :sprint_holidays, :user_id
  end
end
