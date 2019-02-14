class AddColumnSourceToTables < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :source, :jsonb, null: false
    add_column :users, :source, :jsonb, null: false
  end
end
