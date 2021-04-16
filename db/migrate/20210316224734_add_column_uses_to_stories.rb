# frozen_string_literal: true

class AddColumnUsesToStories < ActiveRecord::Migration[6.1]
  def change
    add_column :stories, :repeatable, :boolean, default: false, index: true
  end
end
