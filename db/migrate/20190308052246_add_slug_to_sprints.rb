class AddSlugToSprints < ActiveRecord::Migration[5.2]
  def change
    add_column :sprints, :slug, :string
    add_index :sprints, :slug, unique: true
  end
end
