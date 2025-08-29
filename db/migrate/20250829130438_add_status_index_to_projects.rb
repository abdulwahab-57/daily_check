class AddStatusIndexToProjects < ActiveRecord::Migration[7.2]
  def change
    add_index :projects, :status
  end
end
