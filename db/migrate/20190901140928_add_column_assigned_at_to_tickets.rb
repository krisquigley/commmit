class AddColumnAssignedAtToTickets < ActiveRecord::Migration[6.0]
  def change
    add_column :tickets, :assigned_at, :datetime
    add_column :sprint_tickets, :assigned_at, :datetime
    add_index :tickets, :assigned_at
  end
end
