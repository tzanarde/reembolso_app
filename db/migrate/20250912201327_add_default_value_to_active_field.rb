class AddDefaultValueToActiveField < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :active, 1
  end
end
