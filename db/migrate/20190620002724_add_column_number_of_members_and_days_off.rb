# frozen_string_literal: true

class AddColumnNumberOfMembersAndDaysOff < ActiveRecord::Migration[5.2]
  def change
    add_column :sprints, :no_of_members, :integer
    add_column :sprints, :days_off, :decimal
  end
end
