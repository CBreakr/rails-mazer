class CreateJourneys < ActiveRecord::Migration[6.0]
  def change
    create_table :journeys do |t|
      t.integer :user_id
      t.integer :maze_id
      t.boolean :is_finished

      t.timestamps
    end
  end
end
