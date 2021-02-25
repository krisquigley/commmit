class CreateAccountTable < ActiveRecord::Migration[6.1]
  def change
    # Enable UUIDs
    enable_extension 'pgcrypto'

    # Create accounts tables
    create_table :accounts do |t|
      t.string :name,       null: false
      t.string :subdomain,  null: false
      t.bigint :owner_user_id, null: false
      t.string :account_type, null: false, default: 'personal'
      
      t.index [:owner_user_id, :account_type]
      t.index :owner_user_id
      t.index :subdomain, unique: true
      t.timestamps
    end

    tables = [:retrospectives, :sprint_tickets, :sprints, 
              :teams, :tickets]

    # Update existing tables to be scoped to account too
    tables.each do |table|
      add_column table, :account_id, :bigint, null: false

      add_index table, :account_id
    end

    create_table :accounts_users, id: false do |t|
      t.belongs_to :account
      t.belongs_to :user
    end
  end
end
