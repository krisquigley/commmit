class CreateSprintsUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :sprints_users, id: false do |t|
      t.belongs_to :sprint, index: true
      t.belongs_to :user, index: true
    end
  end
end
