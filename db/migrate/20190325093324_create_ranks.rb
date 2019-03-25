class CreateRanks < ActiveRecord::Migration[5.2]
  def change
    create_table :ranks do |t|
      t.references :race, foreign_key: true
      t.integer :rane
      t.integer :rank

      t.timestamps
    end
  end
end
