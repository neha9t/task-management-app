class AddIndexToTasks < ActiveRecord::Migration[5.0]
  def change
    add_index :tasks, [:name, :description], :type => :fulltext
  end
end
