# frozen_string_literal: true

class AddColumnSourceToSprintTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :sprint_tickets, :source, :jsonb
  end
end
