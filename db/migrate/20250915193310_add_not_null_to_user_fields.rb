class AddNotNullToUserFields < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :name, :string, null: false
    change_column :users, :role, :string, null: false
    change_column :users, :active, :string, null: false
  end
end
