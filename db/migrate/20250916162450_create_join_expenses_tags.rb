class CreateJoinExpensesTags < ActiveRecord::Migration[7.1]
  def change
    create_join_table :expenses, :tags do |t|
      t.index [ :expense_id, :tag_id ]
      t.index [ :tag_id, :expense_id ]

      t.timestamps
    end
  end
end
