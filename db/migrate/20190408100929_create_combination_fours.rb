class CreateCombinationFours < ActiveRecord::Migration[5.2]
  def change
    create_table :combination_fours do |t|
      t.references :race, foreign_key: true
      t.integer :rane
      t.string :u_name
      t.integer :player_id1
      t.integer :player_id2
      t.integer :player_id3
      t.integer :player_id4

      t.timestamps
    end
  end
end
