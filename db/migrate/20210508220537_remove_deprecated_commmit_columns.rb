# frozen_string_literal: true

class RemoveDeprecatedCommmitColumns < ActiveRecord::Migration[6.1]
  def change
    remove_column :commmits, :start_date, :date, index: true
    remove_column :commmits, :length_in_days, :integer

    change_column_default :commmits, :end_date, from: nil, to: -> { 'CURRENT_DATE' }
    change_column_null :commmits, :end_date, false
  end
end
