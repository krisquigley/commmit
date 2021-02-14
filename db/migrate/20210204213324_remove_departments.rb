class RemoveDepartments < ActiveRecord::Migration[6.1]
  def up
    drop_table :departments
    remove_column :teams, :department_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
