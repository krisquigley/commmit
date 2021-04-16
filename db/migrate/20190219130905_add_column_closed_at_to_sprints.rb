# frozen_string_literal: true

class AddColumnClosedAtToSprints < ActiveRecord::Migration[5.2]
  def change
    add_column :sprints, :closed_at, :datetime
    add_index :sprints, :closed_at
  end
end
