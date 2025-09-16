class AddUserRoleManagerConstraint < ActiveRecord::Migration[7.1]
  def change
    execute <<-SQL
      ALTER TABLE users
      ADD CONSTRAINT role_manager_check
      CHECK (
        (role = 'E' AND manager_user_id IS NOT NULL) OR
        (role = 'M' AND manager_user_id IS NULL)
      )
    SQL
  end
end
