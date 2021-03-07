class CreateStories < ActiveRecord::Migration[6.1]
  def change
    create_table :stories do |t|
      t.string :i_want, null: false
      t.string :so_that
      t.string :slug
      t.text :notes

      t.belongs_to :account
      t.timestamps
    end

    add_index :stories, :i_want
  end
end
