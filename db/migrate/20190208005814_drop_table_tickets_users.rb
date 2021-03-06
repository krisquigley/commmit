# frozen_string_literal: true

class DropTableTicketsUsers < ActiveRecord::Migration[5.2]
  def change
    drop_table :tickets_users
  end
end
