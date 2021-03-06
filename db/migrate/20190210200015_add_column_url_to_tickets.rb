# frozen_string_literal: true

class AddColumnUrlToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :url, :string, null: false
  end
end
