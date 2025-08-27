class AddDetailsToProjects < ActiveRecord::Migration[7.2]
  def change
    add_column :projects, :slug, :string, null: false
    add_column :projects, :description, :text
    add_column :projects, :status, :integer, null: false, default: 1
    add_column :projects, :start_date, :date
    add_column :projects, :due_date, :date
    add_column :projects, :todos_count, :integer, null: false, default: 0
    add_column :projects, :completed_todos_count, :integer, null: false, default: 0

    add_index :projects, :slug, unique: true
  end
end
