class CreateMazes < ActiveRecord::Migration[6.0]
  def change
    create_table :mazes do |t|
      t.string :name
      t.integer :length
      t.integer :width
      t.string :maze_array_string
      t.integer :iteration

      t.timestamps
    end
  end
end
