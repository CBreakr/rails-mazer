class AddCheckModeToMaze < ActiveRecord::Migration[6.0]
  def change
    add_column :mazes, :check_mode, :boolean
  end
end
