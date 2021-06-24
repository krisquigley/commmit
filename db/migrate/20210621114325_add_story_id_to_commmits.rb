# frozen_string_literal: true

class AddStoryIdToCommmits < ActiveRecord::Migration[6.1]
  def change
    add_column :commmits, :story_id, :bigint
    add_index :commmits, :story_id
  end
end
