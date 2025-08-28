class AddParentIdToTodos < ActiveRecord::Migration[7.2]
  def change
    add_reference :todos, :parent, foreign_key: { to_table: :todos }, index: true, null: true
  end
end
