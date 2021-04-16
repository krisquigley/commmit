# frozen_string_literal: true

class CreateTicketsAndUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets_users, id: false do |t|
      t.belongs_to :ticket, index: true
      t.belongs_to :user, index: true
    end
  end
end
