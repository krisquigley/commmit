# frozen_string_literal: true

class MakeDaysOfDefaultToZero < ActiveRecord::Migration[5.2]
  def change
    change_column_default :sprints, :days_off, 0
  end
end
