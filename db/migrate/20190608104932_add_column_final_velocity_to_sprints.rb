# frozen_string_literal: true

class AddColumnFinalVelocityToSprints < ActiveRecord::Migration[5.2]
  def change
    add_column :sprints, :final_velocity, :decimal
  end
end
