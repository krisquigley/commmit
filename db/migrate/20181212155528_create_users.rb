class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.integer :team_id, null: false
    end

    add_index :users, :team_id
  end
end
