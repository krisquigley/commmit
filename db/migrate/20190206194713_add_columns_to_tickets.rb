class AddColumnsToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :issue_id, :integer, null: false
    add_column :tickets, :repository_name, :string, null: false
    add_column :tickets, :number, :integer, null: false
    add_column :tickets, :state, :string, null: false
    remove_column :tickets, :url, :string, null: false
    rename_column :tickets, :merged_at, :closed_at
    add_index :tickets, :issue_id
  end
end
