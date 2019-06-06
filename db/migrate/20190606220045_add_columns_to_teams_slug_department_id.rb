class AddColumnsToTeamsSlugDepartmentId < ActiveRecord::Migration[5.2]
  def change
    add_column :teams, :slug, :string
    add_column :teams, :department_id, :integer
    add_index :teams, :department_id
    add_index :teams, :slug
  end
end
