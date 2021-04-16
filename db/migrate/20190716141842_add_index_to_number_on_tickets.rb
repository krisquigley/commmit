# frozen_string_literal: true

class AddIndexToNumberOnTickets < ActiveRecord::Migration[5.2]
  def change
    add_index :tickets, :number
  end
end
