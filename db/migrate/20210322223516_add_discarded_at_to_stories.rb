# frozen_string_literal: true

class AddDiscardedAtToStories < ActiveRecord::Migration[6.1]
  def change
    add_column :stories, :discarded_at, :datetime
    add_index :stories, :discarded_at
  end
end
