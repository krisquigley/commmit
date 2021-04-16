# frozen_string_literal: true

class AddSlugToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :slug, :string
    add_index :accounts, :slug
  end
end
