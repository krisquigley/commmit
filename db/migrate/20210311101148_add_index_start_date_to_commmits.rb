# frozen_string_literal: true

class AddIndexStartDateToCommmits < ActiveRecord::Migration[6.1]
  def change
    add_index :commmits, :start_date
  end
end
