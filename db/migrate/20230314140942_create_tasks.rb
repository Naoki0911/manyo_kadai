class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :content
      t.date :limit
      t.string :status
      t.integer :priority

      t.timestamps
    end
  end
end
