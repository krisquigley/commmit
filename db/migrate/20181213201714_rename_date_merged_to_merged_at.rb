class RenameDateMergedToMergedAt < ActiveRecord::Migration[5.2]
  def change
    rename_column :tickets, :date_merged, :merged_at
  end
end
