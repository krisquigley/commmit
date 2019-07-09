class AddColumnAverageHappinessToRetrospectives < ActiveRecord::Migration[5.2]
  def change
    add_column :retrospectives, :average_happiness, :float
  end
end
