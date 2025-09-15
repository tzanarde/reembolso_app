class AddLimitToUserFields < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :name, :string, limit: 50
    change_column :users, :email, :string, limit: 60
    change_column :users, :role, :string, limit: 1
  end
end
