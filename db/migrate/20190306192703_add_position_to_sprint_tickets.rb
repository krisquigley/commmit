class AddPositionToSprintTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :sprint_tickets, :position, :integer
    add_index :sprint_tickets, :position
  end
end
