class AddIndexToClosedAtOnTickets < ActiveRecord::Migration[5.2]
  def change
    add_index :tickets, :closed_at
  end
end
