# frozen_string_literal: true

class AddDiscardedAtToCommmits < ActiveRecord::Migration[6.1]
  def change
    add_column :commmits, :discarded_at, :datetime
    add_index :commmits, :discarded_at
  end
end
