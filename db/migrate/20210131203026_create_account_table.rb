class CreateAccountTable < ActiveRecord::Migration[6.1]
  def up
    # Enable UUIDs
    enable_extension 'pgcrypto'

    # Create accounts tables
    create_table :accounts do |t|
      t.string :name,       null: false
      t.string :subdomain,  null: false
      
      t.index :subdomain, unique: true
      t.index :name, unique: true
      t.timestamps
    end
    
    # Create a default account
    if Ticket.first
      account = Account.create(name: 'default', subdomain: 'default')
    end

    tables = [:retrospectives, :sprint_tickets, :sprints, 
              :teams, :tickets, :users]
      
    # Update existing tables to be scoped to account too
    tables.each do |table|
      add_column table, :account_id, :bigint
      add_index table, :account_id

      if account 
        execute <<-SQL
          UPDATE #{table} SET account_id = #{account.id}
        SQL
      end

      change_column_null table, :account_id, false
    end
  end
      
  def down
    raise ActiveRecord::IrreversibleMigration
  end

  class Ticket < ApplicationRecord; end
  class Account < ApplicationRecord; end
end
