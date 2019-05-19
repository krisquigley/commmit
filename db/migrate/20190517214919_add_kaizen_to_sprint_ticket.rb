class AddKaizenToSprintTicket < ActiveRecord::Migration[5.2]
  def change
    add_column :sprint_tickets, :kaizen, :boolean
  end
end
