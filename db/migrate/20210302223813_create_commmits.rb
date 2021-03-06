class CreateCommmits < ActiveRecord::Migration[6.1]
  def up
    create_table :commmits do |t|
      t.string  :name, null: false
      t.integer :length_in_days, null: false, default: 1
      t.string  :slug
      t.date    :start_date, null: false, default: -> { 'CURRENT_DATE' }
      t.belongs_to :account, null: false

      t.timestamps
    end

    add_index :commmits, :slug
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

 