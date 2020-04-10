class AddCreatorToMaze < ActiveRecord::Migration[6.0]
  def change
    add_column :mazes, :creator_id, :integer
  end
end
