class AddJourneyMazeString < ActiveRecord::Migration[6.0]
  def change
    add_column :journeys, :maze_state_string, :string
  end
end
