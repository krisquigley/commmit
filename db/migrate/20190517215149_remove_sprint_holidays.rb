class RemoveSprintHolidays < ActiveRecord::Migration[5.2]
  def change
    drop_table :sprint_holidays
  end
end
