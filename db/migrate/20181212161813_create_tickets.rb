class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.string :title, null: false
      t.integer :user_id
      t.integer :estimated_effort, null: false
      t.integer :actual_effort
      t.datetime :date_merged
      t.integer :sprint_id
      t.string :url, null: false
      t.timestamps
    end

    add_index :tickets, :sprint_id
    add_index :tickets, :user_id
  end
end
