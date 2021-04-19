# frozen_string_literal: true

class AddColumnEndDateToCommmits < ActiveRecord::Migration[6.1]
  def change
    add_column :commmits, :end_date, :date
    add_index :commmits, :end_date

    Commmit.all.each do |commmit|
      commmit.update(end_date: commmit.start_date + (commmit.length_in_days - 1))
    end

    change_column_null :commmits, :end_date, null: false
  end

  class Commmit < ActiveRecord::Base; end
end
