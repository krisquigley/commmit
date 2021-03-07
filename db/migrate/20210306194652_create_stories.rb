class CreateStories < ActiveRecord::Migration[6.1]
  def change
    create_table :stories do |t|
      t.string :i_want_to, null: false
      t.string :so_that
      t.string :slug
      t.text :notes

      t.belongs_to :account
      t.timestamps
    end
  end
end
