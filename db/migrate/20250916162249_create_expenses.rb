class CreateExpenses < ActiveRecord::Migration[7.1]
  def change
    create_table :expenses do |t|
      t.string :description, null: false, limit: 80
      t.date :date, null: false
      t.decimal :amount, null: false
      t.string :location, null: false, limit: 50
      t.string :status, null: false, limit: 1
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
