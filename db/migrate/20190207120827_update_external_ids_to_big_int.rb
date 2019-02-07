class UpdateExternalIdsToBigInt < ActiveRecord::Migration[5.2]
  def up
    change_column :tickets, :issue_id, :bigint
  end

  def down
    change_column :tickets, :issue_id, :integer
  end
end
