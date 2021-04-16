# frozen_string_literal: true

class MiscCleanup < ActiveRecord::Migration[6.1]
  def change
    # Misc. cleanup
    change_column :friendly_id_slugs, :sluggable_id, :bigint

    change_column :sprint_tickets, :sprint_id, :bigint

    change_column :tickets, :sprint_id, :bigint

    change_column :users, :team_id, :bigint
  end
end
