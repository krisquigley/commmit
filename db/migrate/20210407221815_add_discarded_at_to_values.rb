class AddDiscardedAtToValues < ActiveRecord::Migration[6.1]
  def change
    add_column :values, :discarded_at, :datetime
    add_index :values, :discarded_at
  end
end
