# frozen_string_literal: true

class AddColumnNotesSprintTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :sprint_tickets, :notes, :text
  end
end
