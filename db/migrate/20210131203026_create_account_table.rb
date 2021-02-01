class CreateAccountTable < ActiveRecord::Migration[6.1]
  def up
    # Enable UUIDs
    enable_extension 'pgcrypto'

    # Create accounts tables
    create_table :accounts, id: :uuid do |t|
      t.string :name,       null: false
      t.string :subdomain,  null: false, index: true
      
      t.timestamps
    end
    
    # Create a default account
    if Ticket.first
      account = Account.create(name: 'default', subdomain: 'default')
    end

    tables = [:retrospectives, :sprint_tickets, :sprints, 
              :sprint_users, :teams, :tickets, :users]
      
    # Update existing tables to be scoped to account too
    tables.each do |table|
      add_column table, :account_id, :uuid

      if account 
        execute <<-SQL
          UPDATE #{table} SET account_id = #{account.id}
        SQL
      end

      change_column_null table, account_id, false
    end
      
    # Migrate the rest of the tables to UUID
    # Add UUID columns
    tables.each do |table|
      add_column table, :uuid, :uuid, null: false, default: -> { "gen_random_uuid()" }
    end

    associations = [{ 
      retrospectives: :sprint
    }, {
      retrospectives: :user
    }, {
      sprint_tickets: :issue
    }, {
      sprint_tickets: :sprint
    }, {
      sprints: :team
    }, {
      sprints_users: :sprint
    }, {
      sprints_users: :user
    }, {
      teams: :user
    }, {
      tickets: :issue
    }, {
      tickets: :sprint
    }, {
      users: :team
    }, {
      users: :github_user
    }]
    
    associations.each do |parent_table, column|
      # Add UUID columns for associations
      add_column parent_table, `#{column}_uuid`, :uuid
      
      # Populate UUID columns for associations
      execute <<-SQL
        UPDATE #{parent_table} SET #{column}_uuid =  #{column}s.uuid
        FROM #{column} WHERE #{parent_table}.sprint_id = #{column}s.id;
      SQL

      # Change null
      change_column_null parent_table, `#{column}_uuid`, false

      # Migrate UUID to ID for associations
      remove_column parent_table, `#{column}_id`
      rename_column parent_table, `#{column}_uuid`, `#{column}_id`

      # Add indexes for associations
      add_index parent_table, `#{column}_id`

      # Add foreign keys
      add_foreign_key parent_table, `#{column}s`
    end

    # Special column
    add_column :sprints, :initial_ticket_uuids, :uuid, default: [], array: true
    execute <<-SQL
      UPDATE sprints SET initial_ticket_uuids = sprints.initial_ticket_ids
    SQL
    change_column_null :sprints, :initial_ticket_uuids, false
    remove_column :sprints, :initial_ticket_ids
    rename_column :sprints, :initial_ticket_uuids, :initial_ticket_ids
    add_index :sprints, :initial_ticket_ids

    # Migrate primary keys from UUIDs to IDs
    tables.each do |table|
      remove_column table,    :id
      rename_column table,    :uuid, :id
      execute `ALTER TABLE #{table} ADD PRIMARY KEY (id);`
      add_index table,    :created_at
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  class Account < ApplicationRecord; end
  class Ticket < ApplicationRecord; end
end
