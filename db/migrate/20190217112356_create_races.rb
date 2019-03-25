class CreateRaces < ActiveRecord::Migration[5.2]
  def change
    create_table :races do |t|
      t.integer :year
      t.integer :tour
      t.integer :race_no
      t.string :race_name
      t.string :stage
      t.integer :set
      t.timestamps
    end
  end
end
