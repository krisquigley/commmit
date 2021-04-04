# frozen_string_literal: true

class RemoveAllSlugs < ActiveRecord::Migration[6.1]
  def up
    drop_table :friendly_id_slugs
    remove_index :accounts, :slug
    remove_column :accounts, :slug

    remove_index :commmits, %i[slug account_id]
    remove_column :commmits, :slug

    remove_column :stories, :slug

    remove_index :tags, %i[slug account_id]
    remove_column :tags, :slug

    remove_index :teams, %i[slug account_id]
    remove_column :teams, :slug

    remove_index :users, :slug
    remove_column :users, :slug
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
