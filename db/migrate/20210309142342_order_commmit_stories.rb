# frozen_string_literal: true

class OrderCommmitStories < ActiveRecord::Migration[6.1]
  def change
    add_index :stories, %i[completed_at created_at], order: { completed_at: 'DESC NULLS LAST' }
    add_column :commmits, :stories_count, :integer
  end
end
