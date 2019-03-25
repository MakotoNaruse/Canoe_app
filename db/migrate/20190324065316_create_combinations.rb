class CreateCombinations < ActiveRecord::Migration[5.2]
  def change
    create_table :combinations do |t|
      t.references :race, foreign_key: true
      t.integer :rane
      t.integer :player_id

      t.timestamps
    end
  end
end
