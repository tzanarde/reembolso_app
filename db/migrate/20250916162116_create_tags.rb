class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.string :description, null: false, limit: 20

      t.timestamps
    end
  end
end
