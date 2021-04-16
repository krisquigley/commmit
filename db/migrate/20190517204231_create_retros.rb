# frozen_string_literal: true

class CreateRetros < ActiveRecord::Migration[5.2]
  def change
    create_table :retro_feedback do |t|
      t.belongs_to :sprint, null: false
      t.belongs_to :user
      t.float :role_happiness, null: false
      t.float :team_happiness
      t.float :company_happiness, null: false
      t.string :feedback, null: false
      t.string :happiness_goal, null: false

      t.timestamps
    end
  end
end
