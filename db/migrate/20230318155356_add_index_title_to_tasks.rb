class AddIndexTitleToTasks < ActiveRecord::Migration[6.1]
  def change
    add_index :tasks, :title
  end
end
