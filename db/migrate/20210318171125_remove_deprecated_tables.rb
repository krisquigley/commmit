# frozen_string_literal: true

class RemoveDeprecatedTables < ActiveRecord::Migration[6.1]
  def up
    drop_table :retrospectives
    drop_table :sprint_tickets
    drop_table :sprints
    drop_table :sprints_users
    drop_table :tickets
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
