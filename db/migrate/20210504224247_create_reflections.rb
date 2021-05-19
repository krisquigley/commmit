# frozen_string_literal: true

class CreateReflections < ActiveRecord::Migration[6.1]
  def change
    create_table :reflections do |t|
      t.belongs_to :account, null: false
      t.belongs_to :commmit, null: false

      t.integer :happiness, null: false
      t.boolean :goal_met, default: false, null: false

      t.text :notes

      t.timestamps
    end
  end
end
