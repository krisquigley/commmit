class RemoveUsersDefaultValues < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :name, :username
    change_column_default(:users, :email, from: "", to: nil)
    change_column_default(:users, :encrypted_password, from: "", to: nil)

    add_index :users, :email,                unique: true
    add_index :users, :username,             unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :unlock_token,         unique: true
  end
end
