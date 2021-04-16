# frozen_string_literal: true

class AddIndexToRepositoryNameAndTitle < ActiveRecord::Migration[5.2]
  def change
    add_index :tickets, :title
    add_index :tickets, :repository_name
  end
end
