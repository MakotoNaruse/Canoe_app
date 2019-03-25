class CreateResults < ActiveRecord::Migration[5.2]
  def change
    create_table :results do |t|
      t.references :race, foreign_key: true
      t.integer :rane
      t.string :m
      t.string :s
      t.string :c
      t.string :option

      t.timestamps
    end
  end
end
