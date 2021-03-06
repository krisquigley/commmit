# frozen_string_literal: true

class RemoveColumnActualEffortFromTickets < ActiveRecord::Migration[5.2]
  def change
    remove_column :tickets, :actual_effort, :integer
  end
end
