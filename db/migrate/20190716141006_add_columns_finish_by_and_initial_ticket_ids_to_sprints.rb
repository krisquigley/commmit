# frozen_string_literal: true

class AddColumnsFinishByAndInitialTicketIdsToSprints < ActiveRecord::Migration[5.2]
  def change
    add_column :sprints, :finish_by, :datetime
    add_column :sprints, :initial_ticket_ids, :bigint, array: true, default: []
    add_index :sprints, :initial_ticket_ids
  end
end
