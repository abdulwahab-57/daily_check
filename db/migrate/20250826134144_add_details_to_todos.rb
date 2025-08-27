class AddDetailsToTodos < ActiveRecord::Migration[7.2]
  def change
    add_column :todos, :description, :text
    add_column :todos, :status, :integer, null: false, default: 0
    add_column :todos, :priority, :integer, null: false, default: 1
    add_column :todos, :due_date, :date
    add_column :todos, :starts_at, :datetime
    add_column :todos, :completed_at, :datetime
    add_column :todos, :estimate_minutes, :integer, null: false, default: 0
    add_column :todos, :time_spent_minutes, :integer, null: false, default: 0

    add_index :todos, :status
    add_index :todos, :due_date
  end
end
