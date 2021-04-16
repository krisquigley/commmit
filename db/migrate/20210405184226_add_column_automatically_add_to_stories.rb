# frozen_string_literal: true

class AddColumnAutomaticallyAddToStories < ActiveRecord::Migration[6.1]
  def change
    add_column :stories, :automatically_add, :boolean, default: false

    Story.all(&:save)
    change_column_null :stories, :automatically_add, false
    change_column_null :stories, :repeatable, false
    add_index :stories, :automatically_add
  end

  class Story < ActiveRecord::Base; end
end
