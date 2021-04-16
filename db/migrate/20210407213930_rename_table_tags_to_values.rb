# frozen_string_literal: true

class RenameTableTagsToValues < ActiveRecord::Migration[6.1]
  def change
    # Tags
    remove_index :tags, :account_id
    rename_table :tags, :values
    add_index :values, :account_id

    # Stories
    remove_index :stories_tags, :tag_id
    rename_column :stories_tags, :tag_id, :value_id
    rename_table :stories_tags, :stories_values
    add_index :stories_values, :value_id

    # Commmits
    drop_table :commmits_tags
  end
end
